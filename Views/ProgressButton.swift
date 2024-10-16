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
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                // Background Circle with Stroke
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 5)
                    .frame(width: 80, height: 80)
                
                // Progress Circle
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(detectionProgress, 1.0)))
                    .stroke(isThresholdReached ? thresholdColor : progressColor, lineWidth: 5)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 0.2), value: detectionProgress)
                    .frame(width: 80, height: 80)
                
                // Central Images with Fading Effect
                ZStack {
                    Image(emptyImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .opacity(1.0 - detectionProgress) // Fades out as progress increases
                    
                    Image(filledImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .opacity(detectionProgress) // Fades in as progress increases
                }
            }
        }
        .padding(.bottom, 30)
        .accessibilityLabel(accessibilityLabel)
        .accessibility(addTraits: .isButton)
    }
}
