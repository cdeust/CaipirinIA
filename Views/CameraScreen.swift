//
//  CameraScreen.swift
//  GroceriesAI
//
//  Created by Clément Deust on 06/08/2024.
//

import SwiftUI

struct CameraScreen: View {
    @EnvironmentObject var appState: AppState
    @Binding var detectedItems: [DetectedItem]
    @State private var navigateToRecipes = false

    var body: some View {
        ZStack {
            CameraPreview(detectedItems: $detectedItems)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)

            DetectionOverlay(detectedItems: detectedItems)

            VStack {
                Spacer()
                if !detectedItems.isEmpty {
                    Button(action: showRecipes) {
                        Text("Show Recipes")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Camera")
        .navigationDestination(isPresented: $navigateToRecipes) {
            CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)
        }
    }

    private func showRecipes() {
        navigateToRecipes = true
    }
}
