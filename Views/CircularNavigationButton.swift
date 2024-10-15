//
//  CircularNavigationButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircularNavigationButton<Destination: View>: View {
    var destination: Destination
    var systemImageName: String
    var backgroundColor: Color
    var foregroundColor: Color
    var progress: Double = 0.0 // Default value when not used
    var isThresholdReached: Bool = false // Default value when not used
    var size: CGFloat = 80
    var accessibilityLabelText: Text

    var body: some View {
        NavigationLink(destination: destination) {
            CircularButtonView(
                systemImageName: systemImageName,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                progress: progress,
                isThresholdReached: isThresholdReached,
                size: size
            )
        }
        .accessibilityLabel(accessibilityLabelText)
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

struct CircularNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CircularNavigationButton(
                destination: CameraView(),
                systemImageName: "camera.fill",
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                size: 80,
                accessibilityLabelText: Text("Open Camera")
            )
            
            // Example without threshold
            CircularNavigationButton(
                destination: HomeView(),
                systemImageName: "house.fill",
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                size: 80,
                accessibilityLabelText: Text("Go to Home")
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
