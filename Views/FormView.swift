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
    @State private var cocktailIngredients: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Favorite Cocktail")) {
                    HStack {
                        TextField("Enter favorite cocktail", text: $favoriteCocktail)
                        Button(action: {
                            if !favoriteCocktail.isEmpty {
                                appState.favoriteCocktails.append(favoriteCocktail)
                                favoriteCocktail = ""
                            }
                        }) {
                            Text("Add")
                        }
                    }
                }

                Section(header: Text("Cocktail Ingredients")) {
                    TextField("Enter cocktail ingredients", text: $cocktailIngredients)
                }

                Section(header: Text("Favorite Cocktails")) {
                    List(appState.favoriteCocktails, id: \.self) { cocktail in
                        Text(cocktail)
                    }
                }

                NavigationLink(destination: CameraView()) {
                    Text("Show Cocktail Recipes")
                }
            }
            .navigationTitle("Cocktail Preferences")
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView().environmentObject(AppState())
    }
}
