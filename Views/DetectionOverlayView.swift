//
//  DetectionOverlayView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct DetectionOverlayView: View {
    @Binding var detectedItems: [DetectedItem]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(detectedItems, id: \.name) { item in
                    BoundingBoxView(boundingBox: item.boundingBox, geometry: geometry)
                        .stroke(Color.green, lineWidth: 2)
                    // Optionally, add labels
                    Text("\(item.name) \(String(format: "%.2f", item.confidence))")
                        .font(.caption)
                        .padding(5)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .position(x: boundingBoxMidX(item.boundingBox, geometry: geometry),
                                 y: boundingBoxMidY(item.boundingBox, geometry: geometry))
                }
            }
        }
    }

    private func boundingBoxMidX(_ boundingBox: CGRect, geometry: GeometryProxy) -> CGFloat {
        let midX = boundingBox.midX * geometry.size.width
        return midX
    }

    private func boundingBoxMidY(_ boundingBox: CGRect, geometry: GeometryProxy) -> CGFloat {
        let midY = (1 - boundingBox.midY) * geometry.size.height // Invert Y axis
        return midY
    }
}
