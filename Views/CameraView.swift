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
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Cocktail Ingredients")) {
                        HStack {
                            TextField("Enter cocktail ingredients", text: $cocktailIngredient)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                if !cocktailIngredient.isEmpty {
                                    appState.cocktailIngredients.append(cocktailIngredient)
                                    cocktailIngredient = ""
                                }
                            }) {
                                Text("Add")
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }

                    Section(header: Text("Ingredients List")) {
                        List(appState.cocktailIngredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                    }
                }
                
                // Navigation buttons
                VStack {
                    NavigationLink(destination: CameraScreen(detectedItems: $appState.detectedItems)) {
                        Text("Show Camera")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 8)

                    NavigationLink(destination: CocktailListView(detectedItems: appState.detectedItems, userEnteredIngredients: appState.cocktailIngredients)) {
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
    }
}
