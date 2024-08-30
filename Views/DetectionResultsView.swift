//
//  DetectionResultsView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 06/08/2024.
//

import SwiftUI

struct DetectionResultsView: View {
    var detectedItems: [DetectedItem]

    var body: some View {
        ZStack {
            ForEach(detectedItems) { item in
                DetectionResultItemView(item: item)
            }
        }
    }
}

struct DetectionResultItemView: View {
    var item: DetectedItem

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.green, lineWidth: 2)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
            )
            .frame(width: item.boundingBox.width, height: item.boundingBox.height)
            .position(x: item.boundingBox.midX, y: item.boundingBox.midY)
            .overlay(
                DetectionLabelView(item: item),
                alignment: .top
            )
    }
}

struct DetectionLabelView: View {
    var item: DetectedItem

    var body: some View {
        Text("\(item.name) \(String(format: "%.2f", item.confidence))")
            .font(.caption)
            .fontWeight(.medium)
            .padding(8)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.teal.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
            .padding(5)
    }
}

struct DetectionResultsView_Previews: PreviewProvider {
    static var previews: some View {
        DetectionResultsView(detectedItems: [
            DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 50, y: 50, width: 100, height: 100)),
            DetectedItem(name: "Mint", confidence: 0.92, boundingBox: CGRect(x: 150, y: 150, width: 100, height: 100))
        ])
        .preferredColorScheme(.light)  // Preview in light mode
        .previewLayout(.sizeThatFits)
        
        DetectionResultsView(detectedItems: [
            DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 50, y: 50, width: 100, height: 100)),
            DetectedItem(name: "Mint", confidence: 0.92, boundingBox: CGRect(x: 150, y: 150, width: 100, height: 100))
        ])
        .preferredColorScheme(.dark)  // Preview in dark mode
        .previewLayout(.sizeThatFits)
    }
}
