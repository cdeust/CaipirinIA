//
//  CircularButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircularButtonView: View {
    var assetImageName: String? // Optional asset image name
    var systemImageName: String? // Optional system image name
    var backgroundColor: Color
    var foregroundColor: Color
    var progress: Double = 0.0 // Value between 0 and 1
    var isThresholdReached: Bool = false
    var size: CGFloat = 80

    var body: some View {
        ZStack {
            // Outer Circle with Progress
            Circle()
                .stroke(Color.white, lineWidth: 5)
                .frame(width: size, height: size)
            
            // Progress Indicator
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(isThresholdReached ? Color.green : Color.blue, lineWidth: 5)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear(duration: 0.2), value: progress)
                .frame(width: size, height: size)
            
            // Inner Circle or "GO" Text
            if isThresholdReached {
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.75, height: size * 0.75)
                
                if let assetImageName = assetImageName {
                    Image(assetImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.5, height: size * 0.5)
                } else if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                        .font(.title)
                        .foregroundColor(.black)
                }
            } else {
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.75, height: size * 0.75)
                
                if let assetImageName = assetImageName {
                    Image(assetImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.5, height: size * 0.5)
                } else if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct CircularButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CircularButtonView(
                assetImageName: "CentralButton", // Use your asset image
                systemImageName: nil,
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                progress: 0.5,
                isThresholdReached: false,
                size: 80
            )
            
            CircularButtonView(
                assetImageName: "CentralButton",
                systemImageName: nil,
                backgroundColor: Color("AccentColor"),
                foregroundColor: .white,
                progress: 1.0,
                isThresholdReached: true,
                size: 80
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
