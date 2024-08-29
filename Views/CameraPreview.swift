//
//  CameraPreview.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var detectedItems: [DetectedItem]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.detectedItems = $detectedItems
        context.coordinator.viewController = viewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Handle any updates to the view controller if needed
    }

    func stopDetection() {
        makeCoordinator().viewController?.stopDetection()
    }

    class Coordinator: NSObject {
        var parent: CameraPreview
        var viewController: CameraViewController?

        init(_ parent: CameraPreview) {
            self.parent = parent
        }
    }
}
