//
//  CameraServiceProtocol.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import AVFoundation
import Vision
import Combine

protocol CameraServiceProtocol {
    var captureSession: AVCaptureSession { get }
    var detectedItemsPublisher: AnyPublisher<[DetectedItem], Never> { get }
    func startSession()
    func stopSession()
    func setVideoOutputDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue)
    func handleError(_ error: Error)
}

class CameraService: NSObject, CameraServiceProtocol {
    // Properties
    private let cameraManager: CameraManager
    private let detectionRequest: VNCoreMLRequest
    private let detectionQueue = DispatchQueue(label: "com.caipirinia.detectionQueue")
    private let detectedItemsSubject = PassthroughSubject<[DetectedItem], Never>()

    var captureSession: AVCaptureSession {
        cameraManager.captureSession
    }

    var detectedItemsPublisher: AnyPublisher<[DetectedItem], Never> {
        detectedItemsSubject.eraseToAnyPublisher()
    }

    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
        // Initialize detection request
        let visionModel: VNCoreMLModel = Constants.Models.detectorVNModel
        detectionRequest = VNCoreMLRequest(model: visionModel)
        detectionRequest.imageCropAndScaleOption = .scaleFill
        
        super.init()
        
        cameraManager.delegate = self
    }

    func startSession() {
        cameraManager.startCamera()
    }

    func stopSession() {
        cameraManager.stopCamera()
    }
    
    func setVideoOutputDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        cameraManager.setDelegate(delegate, queue: queue)
    }
    
    func handleError(_ error: Error) {
        // Handle error appropriately (e.g., log it or present an alert to the user)
        print("Camera service error: \(error.localizedDescription)")
    }
}

// MARK: - CameraManagerDelegate
extension CameraService: CameraManagerDelegate {
    func didOutput(sampleBuffer: CMSampleBuffer) {
        detectionQueue.async { [weak self] in
            guard let self = self,
                  let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
            do {
                try handler.perform([self.detectionRequest])
                if let results = self.detectionRequest.results as? [VNRecognizedObjectObservation] {
                    let detectedItems = results.map { observation -> DetectedItem in
                        let identifier = observation.labels.first?.identifier ?? "Unknown"
                        let confidence = observation.labels.first?.confidence ?? 0.0
                        let boundingBox = observation.boundingBox
                        return DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox)
                    }
                    DispatchQueue.main.async {
                        self.detectedItemsSubject.send(detectedItems)
                    }
                }
            } catch {
                print("Failed to perform detection: \(error.localizedDescription)")
            }
        }
    }
}
