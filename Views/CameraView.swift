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
    @State private var isShowingCocktailList = false
    @State private var cocktailIngredient: String = ""

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
                
                Section(header: Text("Cocktail Ingredients")) {
                    HStack {
                        TextField("Enter cocktail ingredients", text: $cocktailIngredient)
                        Button(action: {
                            if !cocktailIngredient.isEmpty {
                                appState.cocktailIngredients.append(cocktailIngredient)
                                cocktailIngredient = ""
                            }
                        }) {
                            Text("Add")
                        }
                    }
                }
                .padding()

                Button("Show All Recipes") {
                    // Directly navigate to CocktailListView with an empty list
                    appState.detectedItems = [] // Ensure detectedItems is empty
                    isShowingCocktailList = true
                }
                .padding()
                .sheet(isPresented: $isShowingCocktailList) {
                    CocktailListView(detectedItems: appState.detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                }
            }
            .navigationTitle("Camera")
        }
    }
}
