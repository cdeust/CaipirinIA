//
//  DetectionOverlay.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

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
