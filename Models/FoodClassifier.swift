//
//  FoodClassifier.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI
import CoreML
import Vision
import UIKit

class FoodClassifier {
    let model: VNCoreMLModel
    
    init() {
        // Load the YOLOv3Tiny Core ML model
        guard let model = try? VNCoreMLModel(for: LimeDetectorV1(configuration: MLModelConfiguration()).model) else {
            fatalError("Failed to load model")
        }
        self.model = model
    }
    
    func detectObjects(in image: CGImage, completion: @escaping ([VNDetectedObjectObservation]) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion([])
                return
            }
            let detectedObjects = results.map { observation in
                VNDetectedObjectObservation(
                    boundingBox: observation.boundingBox
                )
            }
            completion(detectedObjects)
        }

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing VNCoreMLRequest: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func classify(image: CGImage, completion: @escaping (String) -> Void) {
        // Create a request to classify the image using the loaded model
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let firstResult = results.first else {
                completion("Unknown")
                return
            }
            completion(firstResult.identifier)
        }
        
        // Handle the image request asynchronously on a background thread
        let handler = VNImageRequestHandler(cgImage: image)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion("Error: \(error.localizedDescription)")
            }
        }
    }
}
