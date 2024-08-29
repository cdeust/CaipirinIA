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
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                    )
                    .frame(width: item.boundingBox.width, height: item.boundingBox.height)
                    .position(x: item.boundingBox.midX, y: item.boundingBox.midY)
                    .overlay(
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
                            .padding(5),
                        alignment: .top
                    )
            }
        }
    }
}
