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

        let detectedItems = observations.map { observation -> DetectedItem in
            let identifier = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.labels.first?.confidence ?? 0.0
            let boundingBox = observation.boundingBox
            return DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox)
        }

        DispatchQueue.main.async {
            self.delegate?.didDetectObjects(detectedItems)
        }
    }
}
