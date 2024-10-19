//
//  CameraView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode // For dismissal
    @State private var animateShake = false

    var body: some View {
        ZStack {
            // Camera Preview Layer
            CameraPreview(session: viewModel.cameraService.captureSession)
                .edgesIgnoringSafeArea(.all)

            // Detection Overlay (Optional)
            DetectionOverlayView(detectedItems: $viewModel.detectedItems)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay for controls
            VStack {
                Spacer()
                
                // Show only validated ingredients (green pills)
                if !viewModel.validatedIngredients.isEmpty {
                    DetectedItemsView(items: viewModel.validatedIngredients)
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .bottom)) // Smoothly transition in
                        .animation(.easeInOut(duration: 0.3), value: viewModel.validatedIngredients) // Smooth animation
                }

                // Detection Progress Button (Apple-like style)
                ProgressButton(
                    detectionProgress: viewModel.detectionProgress,
                    isThresholdReached: viewModel.isThresholdReached,
                    action: {
                        if viewModel.isThresholdReached {
                            viewModel.processDetection()
                        } else {
                            // Optional: Add shake or feedback to indicate it's not ready
                            withAnimation(.default) {
                                animateShake.toggle()
                            }
                        }
                    }
                )
                .padding(.bottom, 20) // Add padding at the bottom for spacing
                .offset(x: animateShake ? 5 : 0) // Shake effect
                .animation(
                    Animation.easeInOut(duration: 0.2).repeatCount(animateShake ? 3 : 0, autoreverses: true),
                    value: animateShake
                )

                // Hidden NavigationLink
                NavigationLink(
                    destination: CocktailListView(ingredients: viewModel.validatedIngredients.map { $0.name })
                        .environmentObject(appState),
                    isActive: $viewModel.showCocktailGrid
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .onAppear {
            viewModel.startCamera()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
        .onDisappear {
            viewModel.resetDetectionState() // Reset state on back
            animateShake = false
        }
        .statusBar(hidden: true) // Hide status bar for full-screen experience
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(AppState())
    }
}
