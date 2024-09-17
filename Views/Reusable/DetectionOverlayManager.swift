//
//  DetectionResultsView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 06/08/2024.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

import UIKit
import AVFoundation
import Vision

class DetectionOverlayManager {
    let overlayLayer: CALayer
    private var boxLayers: [CALayer] = []
    private var textLayers: [CATextLayer] = []
    private let screenRect: CGRect

    init(view: UIView) {
        self.screenRect = view.bounds
        self.overlayLayer = CALayer()
        overlayLayer.frame = screenRect
        view.layer.addSublayer(overlayLayer)
    }

    func updateOverlay(with items: [DetectedItem]) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        // Clear existing layers
        clearOverlay()

        // Draw new layers
        for item in items {
            drawDetection(item.boundingBox, text: "\(item.name) (\(String(format: "%.2f", item.confidence)))")
        }

        CATransaction.commit()
    }

    private func drawDetection(_ boundingBox: CGRect, text: String) {
        // Convert normalized bounding box to image coordinates
        let objectBounds = VNImageRectForNormalizedRect(boundingBox, Int(screenRect.width), Int(screenRect.height))

        // Adjust for UIKit coordinate system (origin at top-left)
        let transformedBounds = CGRect(
            x: objectBounds.minX,
            y: screenRect.height - objectBounds.maxY,
            width: objectBounds.width,
            height: objectBounds.height
        )

        // Text label frame positioned above the bounding box
        let textBounds = CGRect(
            x: transformedBounds.minX,
            y: transformedBounds.minY - 20, // Adjust as needed
            width: transformedBounds.width,
            height: 20
        )

        let boxLayer = drawBoundingBox(transformedBounds)
        let textLayer = drawText(textBounds, text)

        overlayLayer.addSublayer(boxLayer)
        overlayLayer.addSublayer(textLayer)
        boxLayers.append(boxLayer)
        textLayers.append(textLayer)
    }

    private func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 2.0
        boxLayer.borderColor = UIColor.red.cgColor
        boxLayer.cornerRadius = 4
        return boxLayer
    }

    private func drawText(_ bounds: CGRect, _ text: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = 14
        textLayer.font = UIFont.systemFont(ofSize: textLayer.fontSize)
        textLayer.alignmentMode = .center
        textLayer.string = text
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textLayer.frame = bounds
        return textLayer
    }

    func clearOverlay() {
        boxLayers.forEach { $0.removeFromSuperlayer() }
        textLayers.forEach { $0.removeFromSuperlayer() }
        boxLayers.removeAll()
        textLayers.removeAll()
    }
}
