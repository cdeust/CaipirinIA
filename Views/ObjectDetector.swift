//
//  ObjectDetector.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import SwiftUI
import CoreML
import Vision

class ObjectDetector {
    private var visionRequests = [VNRequest]()
    var onDetection: (([DetectedItem]) -> Void)?
    
    init() {
        setupVisionModel()
    }
    
    // Set up the Vision model (e.g., CoreML model)
    private func setupVisionModel() {
        guard let modelURL = Bundle.main.url(forResource: Constants.Models.detectorModelName, withExtension: "mlmodelc") else {
            print("Model file not found")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognitionRequest = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processDetection(request, error: error)
            }
            visionRequests = [objectRecognitionRequest]
        } catch {
            print("Error loading Core ML model: \(error)")
        }
    }

    // Detect objects in the given pixel buffer
    func detect(in pixelBuffer: CVPixelBuffer) {
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try requestHandler.perform(visionRequests)
        } catch {
            print("Error performing Vision request: \(error)")
        }
    }

    // Process detection results
    private func processDetection(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedObjectObservation], !observations.isEmpty else {
            print("No results from Vision request: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        let detectedItems = observations.compactMap { observation -> DetectedItem? in
            // Cast observation to recognized object type
            let objectObservation = observation as VNRecognizedObjectObservation
            
//            // Filter by confidence threshold
//            guard objectObservation.confidence >= 0.7 else {
//                return nil
//            }
            
            // Return the detected item
            let identifier = objectObservation.labels.first?.identifier ?? "Unknown"
            return DetectedItem(
                name: identifier,
                confidence: objectObservation.confidence,
                boundingBox: objectObservation.boundingBox
            )
        }

        // Notify detection completion
        onDetection?(detectedItems)
    }
}
