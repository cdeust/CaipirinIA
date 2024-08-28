//
//  CameraScreen.swift
//  GroceriesAI
//
//  Created by Clément Deust on 06/08/2024.
//

import SwiftUI

struct CameraScreen: View {
    @EnvironmentObject var appState: AppState
    @Binding var detectedItems: [DetectedItem]
    @State private var isShowingCocktailList = false

    var body: some View {
        ZStack {
            CameraPreview(detectedItems: $detectedItems)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)

            DetectionOverlay(detectedItems: detectedItems)
            
            VStack {
                Spacer()

                if !detectedItems.isEmpty {
                    Button(action: {
                        isShowingCocktailList = true
                    }) {
                        Text("Show Recipes")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    }
                    .padding()
                    .sheet(isPresented: $isShowingCocktailList) {
                        CocktailListView(detectedItems: detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                    }
                }
            }
        }
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var detectedItems: [DetectedItem]

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.detectedItems = $detectedItems
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Update any necessary parameters in the view controller
    }
}

import AVFoundation
import SwiftUI
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var detectedItems: Binding<[DetectedItem]>?

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var audioPlayer: AVAudioPlayer?
    private var visionRequests = [VNRequest]()
    private var detectionOverlay: CALayer! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAudio()
        setupCamera()
        setupVision()
        setupLayers()
    }

    private func setupAudio() {
        guard let soundURL = Bundle.main.url(forResource: "bottle_detected", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound: \(error)")
        }
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
            print("Model file LimeDetectorV1.mlmodelc not found")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async {
                    self.processVisionRequest(request, error: error)
                }
            })
            self.visionRequests = [objectRecognition]
        } catch {
            print("Error loading Core ML model: \(error)")
        }
    }

    private func setupLayers() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        detectionOverlay.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.layer.addSublayer(detectionOverlay)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let exifOrientation = exifOrientationFromDeviceOrientation()

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print("Error performing Vision request: \(error)")
        }
    }

    private func playSound() {
        audioPlayer?.play()
    }
    
    private func processVisionRequest(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedObjectObservation] else {
            print("No results from Vision request: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        detectionOverlay.sublayers?.removeAll() // Clear previous detection overlays
        
        var newDetectedItems: [DetectedItem] = []
        var bottleDetected = false
        
        for objectObservation in observations {
            let boundingBox = objectObservation.boundingBox
            let transformedRect = self.previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)

            let shapeLayer = createRoundedRectLayerWithBounds(transformedRect)
            let textLayer = createTextSubLayerInBounds(transformedRect, identifier: objectObservation.labels.first?.identifier ?? "Unknown", confidence: objectObservation.confidence)

            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)

            let detectedItem = DetectedItem(
                name: objectObservation.labels.first?.identifier ?? "Unknown",
                confidence: objectObservation.confidence,
                boundingBox: transformedRect
            )
            newDetectedItems.append(detectedItem)
            
            if objectObservation.labels.first?.identifier == "Vodka" ||
                objectObservation.labels.first?.identifier == "Rhum" ||
                objectObservation.labels.first?.identifier == "Gin" ||
                objectObservation.labels.first?.identifier == "Aperol" ||
                objectObservation.labels.first?.identifier == "Perrier" {
                bottleDetected = true
            }
            
            if bottleDetected {
                playSound()
            }
        }

        detectedItems?.wrappedValue = newDetectedItems
    }

    private func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = "\(identifier) \(String(format: "%.2f", confidence))"
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.minY - 20)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textLayer.shadowOpacity = 0.8
        textLayer.shadowRadius = 2.0
        textLayer.shadowColor = UIColor.black.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.cornerRadius = 5
        textLayer.masksToBounds = true
        return textLayer
    }

    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }

    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation

        switch curDeviceOrientation {
        case .portraitUpsideDown:
            exifOrientation = .left
        case .landscapeLeft:
            exifOrientation = .upMirrored
        case .landscapeRight:
            exifOrientation = .down
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        detectionOverlay.frame = view.bounds
    }
}

// Overlay view to display bounding boxes in SwiftUI
struct DetectionOverlay: View {
    var detectedItems: [DetectedItem]

    var body: some View {
        GeometryReader { geometry in
            ForEach(detectedItems) { item in
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.green, lineWidth: 2)
                    .frame(
                        width: item.boundingBox.width * geometry.size.width,
                        height: item.boundingBox.height * geometry.size.height
                    )
                    .position(
                        x: item.boundingBox.midX * geometry.size.width,
                        y: (1 - item.boundingBox.midY) * geometry.size.height
                    )
                    .overlay(
                        Text("\(item.name) \(String(format: "%.2f", item.confidence))")
                            .font(.caption)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(5), alignment: .topLeading
                    )
            }
        }
    }
}
