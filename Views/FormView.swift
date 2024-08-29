//
//  FormView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct FormView: View {
    @EnvironmentObject var appState: AppState
    @State private var favoriteCocktail: String = ""

    var body: some View {
        Form {
            // Section for Adding Favorite Cocktail
            TextFieldWithButton(
                text: $favoriteCocktail, 
                title: "Add Favorite Cocktail",
                placeholder: "Enter favorite cocktail",
                buttonText: "Add",
                onButtonTap: addFavoriteCocktail
            )
            
            // Section for Displaying Favorite Cocktails
            CocktailListSection(
                title: "Favorite Cocktails",
                items: appState.favoriteCocktails,
                emptyMessage: "No favorite cocktails added yet."
            )
            
            // NavigationLink to CameraView
            Section {
                NavigationLink(destination: 
                    CameraView()
                        .environmentObject(appState)
                ) {
                    Text("Show Camera")
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: 
                    CocktailListView(detectedItems: $appState.detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                        .environmentObject(appState)
                ) {
                    Text("Show All Recipes")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Favorite Cocktails")
        .onAppear {
            print("FormView appeared with \(appState.cocktailIngredients.count) ingredients")
        }
        
    }

    // Function to add favorite cocktail
    private func addFavoriteCocktail() {
        if !favoriteCocktail.isEmpty {
            appState.favoriteCocktails.append(favoriteCocktail)
            favoriteCocktail = ""
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
            .environmentObject(AppState()) // Provide AppState for previews
    }
}
