//
//  ProgressButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 16/10/2024.
//

import SwiftUI

struct ProgressButton: View {
    var detectionProgress: Double
    var isThresholdReached: Bool
    var action: () -> Void
    var accessibilityLabel: Text {
        isThresholdReached ? Text("Go to Cocktails") : Text("Capture Photo")
    }
    var progressColor: Color = .blue
    var thresholdColor: Color = .green
    var emptyImageName: String = "CentralButtonEmpty"
    var filledImageName: String = "CentralButton"
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Base Circle with softer stroke and shadow
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

                // Progress Circle with smooth animation
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(detectionProgress, 1.0)))
                    .stroke(isThresholdReached ? thresholdColor : progressColor, lineWidth: 5)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 0.2), value: detectionProgress)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)

                Circle()
                    .fill(Color.white)
                    .frame(width: 80 * 0.75, height: 80 * 0.75)
                
                // Central Image with a fading effect as progress increases
                Image(isThresholdReached ? filledImageName : emptyImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80 * 0.5, height: 80 * 0.5)
                    .opacity(detectionProgress) // Gradually increase opacity as progress reaches 1.0
                    .animation(.easeInOut(duration: 0.2), value: detectionProgress)
            }
        }
        .accessibilityLabel(accessibilityLabel)
        .buttonStyle(PlainButtonStyle())
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
    }
}
