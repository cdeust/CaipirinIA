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
        HStack {
            Spacer()

            // Camera Button inside NavigationLink
            CircularNavigationButton(
                destination: CameraView().environmentObject(appState),
                systemImageName: "camera",
                backgroundColor: .white,
                foregroundColor: .black,
                size: 80, // Adjusted size for consistency
                accessibilityLabelText: Text("Open Camera")
            )
            Spacer()
        }
    }
}

struct FakeTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FakeTabBar()
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
    }
}
