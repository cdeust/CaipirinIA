//
//  CircularCaptureButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircularActionButton: View {
    var systemImageName: String
    var backgroundColor: Color
    var foregroundColor: Color
    var progress: Double // Value between 0 and 1
    var isThresholdReached: Bool
    var size: CGFloat = 80
    var action: () -> Void
    var accessibilityLabelText: Text

    var body: some View {
        Button(action: action) {
            ZStack {
                // Background Circle
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size, height: size)

                // Progress Indicator
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(Color.white.opacity(0.5), lineWidth: 5)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: size, height: size)

                // Button Icon or Text
                if isThresholdReached {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(foregroundColor)
                } else {
                    Image(systemName: systemImageName)
                        .font(.system(size: size * 0.4))
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .accessibilityLabel(accessibilityLabelText)
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

struct CircularActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CircularActionButton(
                systemImageName: "camera.fill",
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                progress: 0.5,
                isThresholdReached: false,
                size: 80,
                action: { print("Capture Photo") },
                accessibilityLabelText: Text("Capture Photo")
            )
            
            CircularActionButton(
                systemImageName: "camera.fill",
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                progress: 1.0,
                isThresholdReached: true,
                size: 80,
                action: { print("Go to Cocktails") },
                accessibilityLabelText: Text("Go to Cocktails")
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
