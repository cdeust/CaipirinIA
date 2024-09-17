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
    @State private var hasNavigated = false
    @State private var confidenceThreshold: Float = 0.6
    @Environment(\.presentationMode) var presentationMode

    private var cameraPreview: CameraPreview {
        CameraPreview(detectedItems: $detectedItems, confidenceThreshold: confidenceThreshold)
    }
    
    // Reference to the CameraViewController
    @State private var cameraViewController: CameraViewController?

    var body: some View {
        ZStack {
            CameraPreview(detectedItems: $detectedItems, confidenceThreshold: confidenceThreshold)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .onDisappear {
                    // Properly stop the camera
                    NotificationCenter.default.post(name: .stopCamera, object: nil)
                }

            VStack {
                VStack(alignment: .leading) {
                    Text("Confidence Threshold: \(String(format: "%.1f", confidenceThreshold))")
                        .font(.headline)
                        .foregroundColor(Color.primary)
                    Slider(value: $confidenceThreshold, in: 0.0...1.0, step: 0.1)
                        .tint(Color.accentColor)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
                .shadow(radius: 2)
                Spacer()
                HStack {
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
            // Start detection when the view appears
            NotificationCenter.default.post(name: .startCamera, object: nil)
        }
        .onDisappear {
            // Properly stop the camera
            NotificationCenter.default.post(name: .stopCamera, object: nil)
        }
        .onChange(of: detectedItems) { oldItems, newItems in
            if !hasNavigated && newItems.contains(where: { $0.name.lowercased().contains("bottle") }) {
                hasNavigated = true
                navigateToRecipes = true
            }
        }
        .onChange(of: navigateToRecipes) { isNavigating in
            if isNavigating {
                // Navigating to CocktailListView, stop the camera
                NotificationCenter.default.post(name: .stopCamera, object: nil)
            }
        }
        .navigationDestination(isPresented: $navigateToRecipes) {
            CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                .environmentObject(appState)
        }
    }

    private func resetCamera() {
        detectedItems.removeAll()
        hasNavigated = false
    }
}
