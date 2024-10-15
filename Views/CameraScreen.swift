//
//  CameraScreen.swift
//  GroceriesAI
//
//  Created by Clément Deust on 06/08/2024.
//

import SwiftUI

struct CameraScreen: View {
    @StateObject private var viewModel = CameraViewModel()
    @EnvironmentObject var appState: AppState
    
    private var cameraPreview: some View {
        CameraPreview(detectedItems: $viewModel.detectedItems, confidenceThreshold: 0.6)
    }
    
    var body: some View {
        ZStack {
            cameraPreview
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .onDisappear {
                    NotificationCenter.default.post(name: .stopCamera, object: nil)
                }
            
            VStack {
                IngredientTagListView(temporaryItems: $viewModel.temporaryDetectedItems)
                Spacer()
            }
            
            VStack {
                Spacer()
                DetectionButton(viewModel: viewModel)
                if viewModel.showDetailButtons {
                    DetailButtonBar()
                }
            }
        }
        .onAppear {
            setupCamera()
        }
        .onDisappear {
            stopCamera()
        }
        .onChange(of: viewModel.detectedItems) { newItems in
            viewModel.handleNewDetections(newItems)
        }
        .navigationDestination(isPresented: $viewModel.navigateToRecipes) {
            CocktailListView(detectedItems: $viewModel.detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                .environmentObject(appState)
        }
    }
    
    // Modularize camera setup actions
    private func setupCamera() {
        viewModel.resetCamera()
        NotificationCenter.default.post(name: .startCamera, object: nil)
    }
    
    // Modularize camera stop actions
    private func stopCamera() {
        NotificationCenter.default.post(name: .stopCamera, object: nil)
    }
}
