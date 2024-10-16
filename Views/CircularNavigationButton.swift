//
//  CircularNavigationButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircularNavigationButton<Destination: View>: View {
    var destination: Destination
    var assetImageName: String? // Optional asset image name
    var systemImageName: String? // Optional system image name
    var backgroundColor: Color
    var foregroundColor: Color
    var progress: Double = 0.0 // Default value when not used
    var isThresholdReached: Bool = false // Default value when not used
    var size: CGFloat = 80
    var accessibilityLabelText: Text

    var body: some View {
        NavigationLink(destination: destination) {
            CircularButtonView(
                assetImageName: assetImageName,
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
        let container = DependencyContainer()
        
        VStack(spacing: 20) {
            CircularNavigationButton(
                destination: CameraView(container: container),
                assetImageName: "CentralButton", // Using asset image
                systemImageName: nil, // No system image provided
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                size: 80,
                accessibilityLabelText: Text("Open Camera")
            )
            
            // Example with system image
            CircularNavigationButton(
                destination: HomeView(container: container),
                assetImageName: nil, // No asset image provided
                systemImageName: "house.fill", // Using system image
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                size: 80,
                accessibilityLabelText: Text("Go to Home")
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
