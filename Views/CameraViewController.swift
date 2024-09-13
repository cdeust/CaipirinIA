//
//  CameraViewController.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import AVFoundation
import UIKit
import SwiftUI
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var detectedItems: Binding<[DetectedItem]>?
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var detectionOverlay: CALayer!
    
    private var frameProcessor: FrameProcessor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the necessary components
        setupCamera()
        setupOverlay()
        
        // Initialize ObjectDetector and FrameProcessor safely
        let objectDetector = ObjectDetector()
        objectDetector.onDetection = { [weak self] detectedItems in
            self?.handleDetectedItems(detectedItems)
        }
        
        // Ensure frameProcessor is initialized
        frameProcessor = FrameProcessor(desiredFrameRate: 15, objectDetector: objectDetector)
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .hd1920x1080
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access camera")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            print("Unable to initialize camera input: \(error.localizedDescription)")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupOverlay() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionResultsView"
        detectionOverlay.bounds = view.bounds
        detectionOverlay.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.layer.addSublayer(detectionOverlay)
    }
    
    // Safely unwrap the frameProcessor before processing frames
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frameProcessor = frameProcessor else {
            print("FrameProcessor is nil")
            return
        }
        frameProcessor.process(sampleBuffer)
    }
    
    func stopDetection() {
        captureSession.stopRunning()
    }
    
    private func handleDetectedItems(_ items: [DetectedItem]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Clear previously drawn items
            if let detectedItemsBinding = self.detectedItems {
                detectedItemsBinding.wrappedValue = []
            }
            
            for detectedItem in items {
                // Convert the normalized bounding box into pixel coordinates
                let transformedRect = self.previewLayer.layerRectConverted(fromMetadataOutputRect: detectedItem.boundingBox)
                
                // **Map detected item name using IngredientMapper**
                let mappedName = IngredientMapper.map(detectedItem.name)
                let mappedDetectedItem = DetectedItem(name: mappedName, confidence: detectedItem.confidence, boundingBox: transformedRect)
                
                // **Add the mapped detected item to the detectedItems list**
                if let detectedItemsBinding = self.detectedItems {
                    if let existingIndex = detectedItemsBinding.wrappedValue.firstIndex(where: { $0.name == mappedDetectedItem.name }) {
                        // Update existing item
                        detectedItemsBinding.wrappedValue[existingIndex] = mappedDetectedItem
                    } else {
                        // Add new item
                        detectedItemsBinding.wrappedValue.append(mappedDetectedItem)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        detectionOverlay.frame = view.bounds
    }
}
