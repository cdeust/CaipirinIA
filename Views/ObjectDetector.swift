//
//  ObjectDetector.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import SwiftUI
import CoreML
import Vision

protocol ObjectDetectorDelegate: AnyObject {
    func didDetectItems(_ items: [DetectedItem])
}

class ObjectDetector {
    weak var delegate: ObjectDetectorDelegate?
    private let detectionQueue = DispatchQueue(label: "com.mobileapp.cdeust.detectionQueue")
    private let model: VNCoreMLModel
    private let request: VNCoreMLRequest

    init() {
        let mlModel = Constants.Models.detectorVNModel
        self.model = mlModel

        request = VNCoreMLRequest(model: mlModel)
        request.imageCropAndScaleOption = .scaleFill
    }

    func detect(pixelBuffer: CVPixelBuffer) {
        detectionQueue.async { [weak self] in
            guard let self = self else { return }

            let request = VNCoreMLRequest(model: self.model) { request, error in
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    let detectedItems = results.map { observation in
                        if let topLabel = observation.labels.first {
                            return DetectedItem(
                                name: topLabel.identifier,
                                confidence: topLabel.confidence,
                                boundingBox: observation.boundingBox
                            )
                        } else {
                            return DetectedItem(
                                name: "Unknown",
                                confidence: 0.0,
                                boundingBox: observation.boundingBox
                            )
                        }
                    }
                    DispatchQueue.main.async {
                        self.delegate?.didDetectItems(detectedItems)
                    }
                }
            }

            request.imageCropAndScaleOption = .scaleFill

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform detection: \(error)")
            }
        }
    }
}
