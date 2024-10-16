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
                }
                
                ProgressButton(detectionProgress: viewModel.detectionProgress, isThresholdReached: viewModel.isThresholdReached, action: {
                    if viewModel.isThresholdReached {
                        viewModel.processDetection()
                    } else {
                        // Trigger detection logic if needed
                    }
                })
                
                // Hidden NavigationLink
                NavigationLink(
                    destination: CocktailListView(ingredients: viewModel.validatedIngredients.map { $0.name }) // Only pass validated ingredients
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
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(AppState())
    }
}
