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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            CameraPreview(detectedItems: $detectedItems)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)

            DetectionOverlay(detectedItems: detectedItems)

            VStack {
                HStack {
                    // Custom back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: colorScheme == .dark ? [Color.orange, Color.red] : [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 10)
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemBackground))
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
