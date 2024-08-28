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
    @State private var cocktailIngredient: String = ""

    var body: some View {
        NavigationView {
            Form {
                // Section for Adding Favorite Cocktail
                Section(header: Text("Add Favorite Cocktail")) {
                    HStack {
                        TextField("Enter favorite cocktail", text: $favoriteCocktail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                        
                        Button(action: addFavoriteCocktail) {
                            Text("Add")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(favoriteCocktail.isEmpty) // Disable button if text field is empty
                    }
                }
                
                // Section for Displaying Favorite Cocktails
                Section(header: Text("Favorite Cocktails")) {
                    if appState.favoriteCocktails.isEmpty {
                        Text("No favorite cocktails added yet.")
                            .foregroundColor(.secondary)
                    } else {
                        List(appState.favoriteCocktails, id: \.self) { cocktail in
                            Text(cocktail)
                        }
                    }
                }
                
                // NavigationLink to CameraView
                Section {
                    NavigationLink(destination: CameraView()) {
                        Text("Show Cocktail Recipes")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Favorite Cocktails")
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
        FormView().environmentObject(AppState())
    }
}
