//
//  CameraView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var appState: AppState
    @State private var cocktailIngredient: String = ""

    var body: some View {
        VStack {
            Form {
                IngredientInputView(cocktailIngredient: $cocktailIngredient, onAdd: addCocktailIngredient)

                IngredientListView(
                    title: "Ingredients List",
                    items: appState.cocktailIngredients,
                    onDelete: removeIngredient
                )
            }

            VStack {
                // NavigationLink to CameraView
                NavigationLink(destination: 
                    CameraScreen(detectedItems: Binding(get: {
                        return appState.detectedItems.isEmpty ? [] : appState.detectedItems
                    }, set: { newValue in
                        appState.detectedItems = newValue
                    }))
                        .environmentObject(appState))
                {
                    Text("Show Camera")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 8)

                // NavigationLink to CocktailListView
                NavigationLink(destination: 
                    CocktailListView(detectedItems: $appState.detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                        .environmentObject(appState)
                ) {
                    Text("Show All Recipes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Cocktail Builder")
    }

    private func addCocktailIngredient() {
        if !cocktailIngredient.isEmpty {
            appState.cocktailIngredients.append(cocktailIngredient)
            cocktailIngredient = ""
        }
    }

    private func removeIngredient(at index: Int) {
        appState.cocktailIngredients.remove(at: index)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(AppState()) // Provide AppState for previews
    }
}
