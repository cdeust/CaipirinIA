//
//  CameraManagerDelegate.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//
import AVFoundation

protocol CameraManagerDelegate: AnyObject {
    func didOutput(sampleBuffer: CMSampleBuffer)
}

class CameraManager: NSObject {
    let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let fps: Int
    public let previewLayer: AVCaptureVideoPreviewLayer
    weak var delegate: CameraManagerDelegate?
    
    init(fps: Int = 30) {
        self.fps = fps
        self.previewLayer = AVCaptureVideoPreviewLayer()
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        // Camera Input
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(videoInput) else {
            print("Error: Could not initialize capture device.")
            return
        }
        captureSession.addInput(videoInput)

        // Set the desired frame rate
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(fps))
            captureDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(fps))
            captureDevice.unlockForConfiguration()
        } catch {
            print("Error setting frame rate: \(error)")
        }

        // Video Output
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.caipirinia.cameraProcessingQueue"))

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()

        // Preview Layer
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
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
    
    func setDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        videoOutput.setSampleBufferDelegate(delegate, queue: queue)
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        delegate?.didOutput(sampleBuffer: sampleBuffer)
    }
}
