//
//  Constants.swift
//  CaipirinIA
//
//  Created by Clément Deust on 10/09/2024.
//

import CoreML
import Vision

struct Constants {
    struct Models {
        static let detectorModelName = "CaipiV3" //Change only this value to the model you want to use
        
        static var detectorVNModel: VNCoreMLModel {
            guard let modelURL = Bundle.main.url(forResource: detectorModelName, withExtension: "mlmodelc") else {
                fatalError("Model file not found: \(detectorModelName)")
            }
            do {
                let mlModel = try MLModel(contentsOf: modelURL)
                return try VNCoreMLModel(for: mlModel)
            } catch {
                fatalError("Failed to load VNCoreMLModel: \(error)")
            }
        }
    }
}
