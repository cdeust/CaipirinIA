//
//  CameraPreview.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI
import UIKit

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var detectedItems: [DetectedItem]
    var confidenceThreshold: Float

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.detectedItems = $detectedItems
        cameraViewController.confidenceThreshold = confidenceThreshold

        // Assign the viewController to the coordinator
        context.coordinator.viewController = cameraViewController

        // Observe the stopCamera notification
        NotificationCenter.default.addObserver(context.coordinator,
                                               selector: #selector(Coordinator.handleStopCameraNotification),
                                               name: .stopCamera,
                                               object: nil)

        // Observe the startCamera notification
        NotificationCenter.default.addObserver(context.coordinator,
                                               selector: #selector(Coordinator.handleStartCameraNotification),
                                               name: .startCamera,
                                               object: nil)

        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.confidenceThreshold = confidenceThreshold
    }

    func stopDetection() {
        // Post the notification to stop the camera
        NotificationCenter.default.post(name: .stopCamera, object: nil)
    }

    class Coordinator: NSObject {
        var parent: CameraPreview
        weak var viewController: CameraViewController?

        init(_ parent: CameraPreview) {
            self.parent = parent
        }

        @objc func handleStopCameraNotification() {
            viewController?.stopDetection()
        }

        @objc func handleStartCameraNotification() {
            viewController?.startDetection()
        }

        deinit {
            NotificationCenter.default.removeObserver(self, name: .stopCamera, object: nil)
            NotificationCenter.default.removeObserver(self, name: .startCamera, object: nil)
        }
    }
}

extension Notification.Name {
    static let stopCamera = Notification.Name("stopCamera")
    static let startCamera = Notification.Name("startCamera")
}
