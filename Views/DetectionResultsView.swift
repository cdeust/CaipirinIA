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
                Rectangle()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: item.boundingBox.width, height: item.boundingBox.height)
                    .position(x: item.boundingBox.midX, y: item.boundingBox.midY)
                    .overlay(
                        Text("\(item.name) \(String(format: "%.2f", item.confidence))")
                            .font(.caption)
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(5),
                        alignment: .top
                    )
            }
        }
    }
}

#Preview {
    DetectionResultsView(detectedItems: [DetectedItem]())
}
