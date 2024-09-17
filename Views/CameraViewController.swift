//
//  CameraViewController.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import UIKit
import AVFoundation
import Vision
import SwiftUI

class CameraViewController: UIViewController {
    var detectedItems: Binding<[DetectedItem]>?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var detectionOverlayManager: DetectionOverlayManager?

    private let detectionQueue = DispatchQueue(label: "com.mobileapp.cdeust.detectionQueue")
    private var coreMLModel: VNCoreMLModel?
    
    var confidenceThreshold: Float = 0.6 // Adjust this value as needed

    // Flag to indicate if detection is running
    private var isDetectionRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupDetectionOverlay()
        setupVision()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
        } else {
            print("Error: previewLayer is nil in viewDidLayoutSubviews.")
        }

        if let overlayLayer = detectionOverlayManager?.overlayLayer {
            overlayLayer.frame = view.bounds
        } else {
            print("Error: overlayLayer is nil in viewDidLayoutSubviews.")
        }
    }

    func startDetection() {
        captureSession?.startRunning()
        detectionOverlayManager?.clearOverlay()
    }
    
    func stopDetection() {
        captureSession?.stopRunning()
        detectionOverlayManager?.clearOverlay()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let captureSession = captureSession else {
            print("Error: captureSession is nil.")
            return
        }

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Error: Unable to access back camera.")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Error: Could not add video input to capture session.")
            return
        }

        videoOutput = AVCaptureVideoDataOutput()
        guard let videoOutput = videoOutput else {
            print("Error: Could not create video output.")
            return
        }

        videoOutput.alwaysDiscardsLateVideoFrames = true

        let videoSettings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.videoSettings = videoSettings

        videoOutput.setSampleBufferDelegate(self, queue: detectionQueue)

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("Error: Could not add video output to capture session.")
            return
        }

        // Set video orientation and rotation
        if let connection = videoOutput.connection(with: .video) {
            if #available(iOS 17.0, *) {
                connection.videoRotationAngle = 0 // Adjust as needed
            } else {
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
            }
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = false
            }
        }

        // Initialize previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let previewLayer = previewLayer {
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.insertSublayer(previewLayer, at: 0)
        } else {
            print("Error: Could not create previewLayer.")
        }

        captureSession.startRunning()
    }

    private func setupDetectionOverlay() {
        detectionOverlayManager = DetectionOverlayManager(view: view)
        if detectionOverlayManager == nil {
            print("Error: Could not initialize detectionOverlayManager.")
        }
    }

    private func setupVision() {
        // Load your Core ML model
        self.coreMLModel = Constants.Models.detectorVNModel
    }

    private func handleDetections(request: VNRequest, error: Error?, confidenceThreshold: Float) {
        guard let results = request.results as? [VNRecognizedObjectObservation] else { return }

        let detectedItems = results.compactMap { observation -> DetectedItem? in
            guard let topLabel = observation.labels.first else { return nil }

            if topLabel.confidence >= confidenceThreshold {
                return DetectedItem(
                    name: topLabel.identifier,
                    confidence: topLabel.confidence,
                    boundingBox: observation.boundingBox
                )
            } else {
                return nil
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.detectionOverlayManager?.updateOverlay(with: detectedItems)
            self.detectedItems?.wrappedValue = detectedItems
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = self.coreMLModel else { return }

        let imageOrientation: CGImagePropertyOrientation = .right // Adjust based on your setup

        // Create a Vision request handler
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: imageOrientation, options: [:])

        // Create a new VNCoreMLRequest
        let detectionRequest = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            // Use self.confidenceThreshold directly to get the latest value
            self.handleDetections(request: request, error: error, confidenceThreshold: self.confidenceThreshold)
        }
        detectionRequest.imageCropAndScaleOption = .scaleFill

        do {
            try requestHandler.perform([detectionRequest])
        } catch {
            print("Failed to perform detection: \(error)")
        }
    }
}
