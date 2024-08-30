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
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
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
                            .fontWeight(.bold)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
                            .padding([.top, .leading], 6),
                        alignment: .topLeading
                    )
            }
        }
    }
}

struct DetectionOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetectionOverlay(detectedItems: [
                DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 0.2, y: 0.3, width: 0.5, height: 0.4)),
                DetectedItem(name: "Mint", confidence: 0.87, boundingBox: CGRect(x: 0.5, y: 0.5, width: 0.3, height: 0.3))
            ])
            .preferredColorScheme(.light)
            
            DetectionOverlay(detectedItems: [
                DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 0.2, y: 0.3, width: 0.5, height: 0.4)),
                DetectedItem(name: "Mint", confidence: 0.87, boundingBox: CGRect(x: 0.5, y: 0.5, width: 0.3, height: 0.3))
            ])
            .preferredColorScheme(.dark)
        }
    }
}
