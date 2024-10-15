//
//  DetectionOverlayManager.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import UIKit
import Vision

class DetectionOverlayManager {
    let overlayLayer: CALayer
    private var boxLayers: [CALayer] = []
    private var textLayers: [CATextLayer] = []
    private let viewBounds: CGRect

    init(view: UIView) {
        self.viewBounds = view.bounds
        overlayLayer = CALayer()
        overlayLayer.frame = viewBounds
        view.layer.addSublayer(overlayLayer)
    }

    func updateOverlay(with items: [DetectedItem]) {
        DispatchQueue.main.async {
            self.clearOverlay()
            for item in items {
                self.drawDetection(item.boundingBox, text: "\(item.name) (\(String(format: "%.2f", item.confidence)))")
            }
        }
    }

    private func drawDetection(_ boundingBox: CGRect, text: String) {
        let convertedRect = VNImageRectForNormalizedRect(boundingBox, Int(viewBounds.width), Int(viewBounds.height))

        // Adjust for UIKit coordinate system
        let rect = CGRect(
            x: convertedRect.minX,
            y: viewBounds.height - convertedRect.maxY,
            width: convertedRect.width,
            height: convertedRect.height
        )

        // Draw bounding box
        let boxLayer = CALayer()
        boxLayer.frame = rect
        boxLayer.borderColor = UIColor.green.cgColor
        boxLayer.borderWidth = 2.0
        overlayLayer.addSublayer(boxLayer)
        boxLayers.append(boxLayer)

        // Draw text label
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 14
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.frame = CGRect(x: rect.minX, y: rect.minY - 20, width: rect.width, height: 20)
        overlayLayer.addSublayer(textLayer)
        textLayers.append(textLayer)
    }

    func clearOverlay() {
        boxLayers.forEach { $0.removeFromSuperlayer() }
        textLayers.forEach { $0.removeFromSuperlayer() }
        boxLayers.removeAll()
        textLayers.removeAll()
    }
}
