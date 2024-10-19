//
//  FakeTabBar.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct FakeTabBar: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background bar with a custom shape for cutout
//            CustomTabBarShape()
//                .fill(Color("BackgroundStart"))
//                .frame(height: 80) // Standard tab bar height
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -2)
//                .edgesIgnoringSafeArea(.bottom)  // Extends the tab bar below safe area

            // Central Camera Button with transparent center
            CircularNavigationButton(
                destination: CameraView().environmentObject(appState),
                assetImageName: "CentralButton",  // Ensure the center part is transparent
                backgroundColor: .clear,          // Clear color for the center
                foregroundColor: .black,
                progress: 100,
                isThresholdReached: true,
                size: 80,
                accessibilityLabelText: Text("Open Camera")
            )
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 3)
            .offset(y: -40) // Offset upwards to fit inside the cutout
        }
        .frame(height: 100) // Overall height with button floating
        .offset(y: 40)
    }
}

struct FakeTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FakeTabBar()
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
    }
}
