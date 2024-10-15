//
//  ObjectDetectorDelegate.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Vision

protocol ObjectDetectorProtocol: AnyObject {
    func didDetectObjects(_ detectedItems: [DetectedItem])
}

class ObjectDetector {
    weak var delegate: ObjectDetectorProtocol?
    private lazy var detectionRequest: VNCoreMLRequest = {
        let model = Constants.Models.detectorVNModel
        let request = VNCoreMLRequest(model: model, completionHandler: self.handleDetection)
        request.imageCropAndScaleOption = .scaleFill
        return request
    }()
    
    private var detectedItemsDict: [String: DetectedItem] = [:]

    init() {
        // No need to initialize detectionRequest here
    }

    func detect(pixelBuffer: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Failed to perform detection: \(error)")
        }
    }

    private func handleDetection(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }

        let newDetectedItems = observations.map { observation -> DetectedItem in
            let identifier = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.labels.first?.confidence ?? 0.0
            let boundingBox = observation.boundingBox
            
            // Check if this object was detected before
            if let existingItem = detectedItemsDict[identifier] {
                // Increment the count if previously detected
                let updatedCount = existingItem.count + 1
                let updatedItem = DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox, count: updatedCount)
                detectedItemsDict[identifier] = updatedItem
                return updatedItem
            } else {
                // First time detecting this object, set count to 1
                let newItem = DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox, count: 1)
                detectedItemsDict[identifier] = newItem // Add to dictionary
                return newItem
            }
        }

        DispatchQueue.main.async {
            self.delegate?.didDetectObjects(newDetectedItems)
        }
    }
}
