//
//  CameraViewController.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import AVFoundation
import Vision
import UIKit
import SwiftUI

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var detectedItems: Binding<[DetectedItem]>?

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var visionRequests = [VNRequest]()
    private var detectionOverlay: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
        setupOverlay()
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

    private func setupVision() {
        guard let modelURL = Bundle.main.url(forResource: "LimeDetectorV1", withExtension: "mlmodelc") else {
            print("Model file not found")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processVisionRequest(request, error: error)
            }

            let textRecognition = VNRecognizeTextRequest { [weak self] request, error in
                self?.processTextRequest(request, error: error)
            }
            textRecognition.recognitionLevel = .accurate
            textRecognition.usesLanguageCorrection = true
            textRecognition.minimumTextHeight = 0.02 // Adjust this to filter small text

            visionRequests = [objectRecognition, textRecognition]
        } catch {
            print("Error loading Core ML model: \(error)")
        }
    }

    private func setupOverlay() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionResultsView"
        detectionOverlay.bounds = view.bounds
        detectionOverlay.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.layer.addSublayer(detectionOverlay)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientationFromDeviceOrientation(), options: [:])
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print("Error performing Vision request: \(error)")
        }
    }

    private func processVisionRequest(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedObjectObservation], !observations.isEmpty else {
            print("No results from Vision request: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.detectionOverlay.sublayers?.removeAll()

            for objectObservation in observations {
                guard let self = self else { return }

                let identifier = objectObservation.labels.first?.identifier ?? "Unknown"
                let confidence = objectObservation.confidence
                let boundingBox = objectObservation.boundingBox
                let transformedRect = self.previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)

                // Check if the detected item already exists or add a new one
                if let existingIndex = self.detectedItems?.wrappedValue.firstIndex(where: { $0.name == identifier }) {
                    if let existingItem = self.detectedItems?.wrappedValue[existingIndex], confidence > existingItem.confidence {
                        self.detectedItems?.wrappedValue[existingIndex].confidence = confidence
                        self.detectedItems?.wrappedValue[existingIndex].boundingBox = transformedRect
                    }
                } else {
                    let detectedItem = DetectedItem(name: identifier, confidence: confidence, boundingBox: transformedRect)
                    self.detectedItems?.wrappedValue.append(detectedItem)

                    // Play sound once for the detected item
                    if self.isAlcohol(identifier) {
                        SoundManager.shared.playSound(named: "Yeepee")
                    } else {
                        SoundManager.shared.playSound(named: "Yum")
                    }

                    // Trigger star animation around the detected item
                    self.showStars(around: transformedRect)
                }
            }
        }
    }

    private func processTextRequest(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
            print("No text detected: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Clear existing layers
            self.detectionOverlay.sublayers?.removeAll()

            // Filter out very small text
            let filteredObservations = observations.filter { $0.boundingBox.height > 0.02 }

            // Merge or eliminate overlapping boxes (simple overlap removal example)
            var nonOverlappingObservations = [VNRecognizedTextObservation]()
            for observation in filteredObservations {
                if !nonOverlappingObservations.contains(where: { $0.boundingBox.intersects(observation.boundingBox) }) {
                    nonOverlappingObservations.append(observation)
                }
            }

            for textObservation in nonOverlappingObservations {
                let boundingBox = textObservation.boundingBox
                let transformedRect = self.previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)

                let text = textObservation.topCandidates(1).first?.string ?? ""
                let textLayer = self.createTextLayer(inBounds: transformedRect, identifier: text, confidence: 1.0)

                let shapeLayer = self.createSubtleRoundedRectLayer(withBounds: transformedRect)
                shapeLayer.addSublayer(textLayer)

                self.detectionOverlay.addSublayer(shapeLayer)
            }
        }
    }

    func stopDetection() {
        captureSession.stopRunning()
    }
    
    private func showStars(around rect: CGRect) {
        let starCount = 5  // Number of stars to display
        let animationDuration: CFTimeInterval = 1.5  // Total duration of the animation

        for i in 0..<starCount {
            let starLayer = createStarLayer()

            // Randomly place stars around the sides of the bounding box
            let startPoint = CGPoint(
                x: rect.origin.x + (i % 2 == 0 ? rect.size.width : 0),
                y: rect.origin.y + CGFloat.random(in: 0...rect.size.height)
            )
            starLayer.position = startPoint
            view.layer.addSublayer(starLayer)

            // Create the path for the star's movement (upward and then down)
            let upwardPath = UIBezierPath()
            upwardPath.move(to: startPoint)

            let controlPoint = CGPoint(
                x: startPoint.x + CGFloat.random(in: -rect.size.width...rect.size.width),
                y: startPoint.y - rect.size.height * 1.5
            )

            let endPoint = CGPoint(
                x: startPoint.x + CGFloat.random(in: -rect.size.width / 2...rect.size.width / 2),
                y: startPoint.y + rect.size.height * 2
            )
            upwardPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)

            // Path animation
            let pathAnimation = CAKeyframeAnimation(keyPath: "position")
            pathAnimation.path = upwardPath.cgPath
            pathAnimation.duration = animationDuration
            pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            // Fade out animation
            let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
            fadeOutAnimation.fromValue = 1.0
            fadeOutAnimation.toValue = 0.0
            fadeOutAnimation.duration = animationDuration
            fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)

            // Group animations
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [pathAnimation, fadeOutAnimation]
            animationGroup.duration = animationDuration

            starLayer.add(animationGroup, forKey: nil)

            // Remove the star layer after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                starLayer.removeFromSuperlayer()
            }
        }
    }

    private func createStarLayer() -> CALayer {
        let starLayer = CATextLayer()
        starLayer.string = "⭐️"
        starLayer.fontSize = 24
        starLayer.alignmentMode = .center
        starLayer.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
        starLayer.contentsScale = UIScreen.main.scale
        starLayer.opacity = 1.0
        return starLayer
    }

    private func createTextLayer(inBounds bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = identifier // Display only the text for recognized text
        textLayer.fontSize = 14
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.minY - 20)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textLayer.alignmentMode = .center
        textLayer.cornerRadius = 5
        textLayer.masksToBounds = true
        return textLayer
    }

    private func createSubtleRoundedRectLayer(withBounds bounds: CGRect) -> CALayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0).cgPath
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.7).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.3
        shapeLayer.shadowOffset = CGSize(width: 2, height: 2)
        shapeLayer.shadowRadius = 4
        return shapeLayer
    }

    private func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portraitUpsideDown: return .left
        case .landscapeLeft: return .upMirrored
        case .landscapeRight: return .down
        default: return .up
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        detectionOverlay.frame = view.bounds
    }
    
    private func isAlcohol(_ itemName: String) -> Bool {
        let alcoholKeywords = ["vodka", "rum", "gin", "tequila", "whiskey", "whisky", "bourbon", "brandy", "cognac", "vermouth", "liqueur", "schnapps", "absinthe", "mezcal", "beer", "wine", "champagne"]

        return alcoholKeywords.contains(where: { itemName.lowercased().contains($0) })
    }
}
