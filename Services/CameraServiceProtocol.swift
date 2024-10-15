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

    private var detectedItemsDict: [String: DetectedItem] = [:]
    private let detectionAccessQueue = DispatchQueue(label: "com.caipirinia.detectionAccessQueue", attributes: .concurrent)
    
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
        detectionQueue.async {
            self.processSampleBuffer(sampleBuffer)
        }
    }

    private func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            try handler.perform([self.detectionRequest])

            if let results = self.detectionRequest.results as? [VNRecognizedObjectObservation] {
                let detectedItems = results.compactMap { observation -> DetectedItem? in
                    let identifier = observation.labels.first?.identifier ?? "Unknown"
                    let confidence = observation.labels.first?.confidence ?? 0.0
                    let boundingBox = observation.boundingBox
                    
                    // Filter out items with confidence lower than 65%
                    guard confidence >= 0.65 else {
                        return nil // Ignore items below confidence threshold
                    }
                    
                    // Check if the item has already been detected
                    var detectedItem: DetectedItem?
                    self.detectionAccessQueue.sync(flags: .barrier) {
                        if let existingItem = self.detectedItemsDict[identifier] {
                            // Increment count if previously detected
                            let updatedCount = existingItem.count + 1
                            detectedItem = DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox, count: updatedCount)
                            self.detectedItemsDict[identifier] = detectedItem
                        } else {
                            // New item detected, set count to 1
                            detectedItem = DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox, count: 1)
                            self.detectedItemsDict[identifier] = detectedItem
                        }
                    }
                    return detectedItem
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
