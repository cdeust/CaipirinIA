//
//  CameraManager.swift
//  CaipirinIA
//
//  Created by Clément Deust on 16/09/2024.
//

import AVFoundation

protocol CameraManagerDelegate: AnyObject {
    func didOutput(pixelBuffer: CVPixelBuffer, timestamp: CMTime)
}

class CameraManager: NSObject {
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let fps: Int
    public var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: CameraManagerDelegate?

    init(fps: Int) {
        self.fps = fps
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480 // Use lower resolution for performance

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Error: Could not initialize capture device.")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        // Set the desired frame rate
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(fps))
            captureDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(fps))
            captureDevice.unlockForConfiguration()
        } catch {
            print("Error setting frame rate: \(error)")
        }

        // Set up video output
        let settings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        ]

        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true

        let processingQueue = DispatchQueue(label: "com.cdeust.cameraProcessingQueue")
        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        if let connection = videoOutput.connection(with: .video) {
            connection.videoRotationAngle = 90.0 // Rotate the video to portrait
        }

        captureSession.commitConfiguration()

        // Initialize preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        
        previewLayer?.connection?.videoOrientation = .portrait

        startCamera()
    }

    func startCamera() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        delegate?.didOutput(pixelBuffer: pixelBuffer, timestamp: timestamp)
    }
}
