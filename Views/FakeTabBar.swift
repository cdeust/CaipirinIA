//
//  FakeTabBar.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct FakeTabBar: View {
    let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }

    var body: some View {
        HStack {
            Spacer()

            // Camera Button inside NavigationLink
            CircularNavigationButton(
                destination: CameraView(container: container).environmentObject(container.resolve(AppState.self)),
                assetImageName: "CentralButton",
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
        let container = DependencyContainer()
        FakeTabBar(container: container)
            .environmentObject(container.resolve(AppState.self))
            .previewLayout(.sizeThatFits)
    }
}
