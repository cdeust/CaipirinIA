//
//  CameraViewControllerDelegate 2.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import UIKit
import AVFoundation
import Vision

protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ controller: CameraViewController, didDetect items: [DetectedItem])
}

class CameraViewController: UIViewController {
    weak var delegate: CameraViewControllerDelegate?

    private var captureSession: AVCaptureSession!
    private var videoOutput: AVCaptureVideoDataOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var detectionRequest: VNCoreMLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            return
        }

        captureSession.addInput(videoInput)

        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        captureSession.addOutput(videoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func setupVision() {
        let model = Constants.Models.detectorVNModel
        detectionRequest = VNCoreMLRequest(model: model, completionHandler: handleDetection)
        detectionRequest.imageCropAndScaleOption = .scaleFill
    }

    private func handleDetection(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedObjectObservation] else { return }

        let detectedItems = results.map { observation -> DetectedItem in
            let identifier = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.labels.first?.confidence ?? 0.0
            let boundingBox = observation.boundingBox
            return DetectedItem(name: identifier, confidence: confidence, boundingBox: boundingBox)
        }

        delegate?.cameraViewController(self, didDetect: detectedItems)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Failed to perform detection: \(error)")
        }
    }
}
