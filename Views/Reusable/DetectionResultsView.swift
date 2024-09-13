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
        .animation(.easeInOut, value: detectedItems) // Animate when detected items change
    }
}

struct DetectionResultItemView: View {
    var item: DetectedItem
    @State private var animateStars = false

    var body: some View {
        // Detection bounding box
        RoundedRectangle(cornerRadius: 3)
            .stroke(Color.red, lineWidth: 2) // Adjust the bounding box stroke
            .frame(width: item.boundingBox.width, height: item.boundingBox.height)
            .position(x: item.boundingBox.midX, y: item.boundingBox.midY)
            .onAppear {
                // Trigger star animation when item appears
                withAnimation(.easeInOut(duration: 1.5)) {
                    animateStars = true
                }
            }
            .overlay(
                ZStack {
                    DetectionLabelView(item: item)
                    if animateStars {
                        createStarView(around: item.boundingBox) // Add star animation around bounding box
                    }
                }
            )
    }

    // Creates the star view to animate around the bounding box
    private func createStarView(around rect: CGRect) -> some View {
        ForEach(0..<5) { index in
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .position(randomStarPosition(around: rect, index: index))
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5).delay(Double(index) * 0.2), value: animateStars)
        }
    }

    // Helper method to randomize star positions
    private func randomStarPosition(around rect: CGRect, index: Int) -> CGPoint {
        let xOffset = CGFloat.random(in: -rect.width/2...rect.width/2)
        let yOffset = CGFloat.random(in: -rect.height...rect.height/2)
        return CGPoint(x: rect.midX + xOffset, y: rect.midY + yOffset)
    }
}

struct DetectionLabelView: View {
    var item: DetectedItem

    var body: some View {
        Text(itemLabel())
            .font(.caption2) // Slightly smaller text
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.gray.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .clipShape(Capsule()) // Rounded capsule shape for labels
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1) // Softer and smaller shadow
            .padding(2)
    }

    // Helper function to determine the label text
    private func itemLabel() -> String {
        if item.name.isEmpty {
            return "\(String(format: "%.2f", item.confidence))" // Only show confidence for text
        } else {
            return "\(item.name) \(String(format: "%.2f", item.confidence))"
        }
    }
}

struct DetectionResultsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetectionResultsView(detectedItems: [
                DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 50, y: 50, width: 100, height: 100)),
                DetectedItem(name: "Mint", confidence: 0.92, boundingBox: CGRect(x: 150, y: 150, width: 100, height: 100)),
                DetectedItem(name: "", confidence: 0.85, boundingBox: CGRect(x: 200, y: 200, width: 100, height: 30)) // Example for text detection
            ])
            .preferredColorScheme(.light)  // Preview in light mode
            .previewLayout(.sizeThatFits)
            
            DetectionResultsView(detectedItems: [
                DetectedItem(name: "Lime", confidence: 0.95, boundingBox: CGRect(x: 50, y: 50, width: 100, height: 100)),
                DetectedItem(name: "Mint", confidence: 0.92, boundingBox: CGRect(x: 150, y: 150, width: 100, height: 100)),
                DetectedItem(name: "", confidence: 0.85, boundingBox: CGRect(x: 200, y: 200, width: 100, height: 30)) // Example for text detection
            ])
            .preferredColorScheme(.dark)  // Preview in dark mode
            .previewLayout(.sizeThatFits)
        }
    }
}
