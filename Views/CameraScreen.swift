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

            DetectionResultsView(detectedItems: detectedItems)

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
                ShowRecipesButton(detectedItems: $appState.detectedItems)
                    .environmentObject(appState)
                    .padding(.horizontal)
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Camera")
        .onAppear {
            resetCamera()
        }
        .navigationDestination(isPresented: $navigateToRecipes) {
            CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                .environmentObject(appState)
        }
    }

    private func resetCamera() {
        detectedItems.removeAll()
    }

    private func showRecipes() {
        navigateToRecipes = true
    }
}
