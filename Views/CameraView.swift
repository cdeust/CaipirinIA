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
                
                // Detected Ingredients Pills
                if !viewModel.detectedIngredients.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.detectedIngredients) { ingredient in
                                Text(ingredient.name)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(ingredient.count > 40 ? Color.green.opacity(0.7) : Color.gray.opacity(0.7))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 10)
                }
                
                // Capture Button with Progress
                Button(action: {
                    if viewModel.isThresholdReached {
                        viewModel.processDetection()
                    } else {
                        // Trigger detection logic if needed
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 5)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(viewModel.detectionCount, viewModel.detectionThreshold)) / CGFloat(viewModel.detectionThreshold))
                            .stroke(viewModel.isThresholdReached ? Color.green : Color.blue, lineWidth: 5)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear(duration: 0.2), value: viewModel.detectionCount)
                            .frame(width: 80, height: 80)
                        
                        ZStack {
                            // Display CentralButtonEmpty with fading effect
                            Image("CentralButtonEmpty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .opacity(1.0 - viewModel.detectionProgress) // Fades out as progress increases

                            // Display CentralButton as it fades in
                            Image("CentralButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .opacity(viewModel.detectionProgress) // Fades in as progress increases
                        }
                    }
                }
                .padding(.bottom, 30)
                .accessibilityLabel(viewModel.isThresholdReached ? Text("Go to Cocktails") : Text("Capture Photo"))
                
                // Hidden NavigationLink
                NavigationLink(
                    destination: CocktailListView(ingredients: viewModel.detectedIngredients.map { $0.name })
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
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(AppState())
    }
}
