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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            CameraPreview(detectedItems: $detectedItems)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true) // Hide the default navigation bar

            DetectionOverlay(detectedItems: detectedItems)

            VStack {
                HStack {
                    // Custom back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Navigate back
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)

                    Spacer()
                }
                
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
                .environmentObject(appState)
        }
    }

    private func showRecipes() {
        navigateToRecipes = true
    }
}
