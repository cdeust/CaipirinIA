//
//  CameraView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var appState: AppState
    @State private var isCameraActive = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CameraScreen(detectedItems: $appState.detectedItems), isActive: $isCameraActive) {
                    EmptyView()
                }

                Button("Show Camera") {
                    isCameraActive = true
                }
                .padding()

                NavigationLink(destination: RecipeListView(detectedItems: appState.detectedItems)) {
                    Text("Show Recipes")
                }
                .padding()
            }
            .navigationTitle("Camera")
        }
    }
}
