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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            // Section for Adding Favorite Cocktail
            TextFieldWithButton(
                text: $favoriteCocktail,
                title: "Add Favorite Cocktail",
                placeholder: "Enter favorite cocktail",
                buttonText: "Add",
                onButtonTap: addFavoriteCocktail
            )
            .environmentObject(appState)
            .padding(.horizontal)

            // Section for Displaying Favorite Cocktails
            CocktailListSection(
                title: "Favorite Cocktails",
                items: appState.favoriteCocktails,
                emptyMessage: "No favorite cocktails added yet.\nNot yet linked with the filtering and generative proposition"
            )
            .environmentObject(appState)
            .padding(.horizontal)

            Spacer()

            // NavigationLink to CameraView and Recipes
            VStack(spacing: 16) {
                NavigationLink(destination:
                    CameraView()
                        .environmentObject(appState)
                ) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: colorScheme == .dark ? [Color.orange, Color.red] : [Color.orange, Color.yellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }

                NavigationLink(destination:
                    CocktailListView(detectedItems: $appState.detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                        .environmentObject(appState)
                ) {
                    Text("Show All Recipes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: colorScheme == .dark ? [Color.green, Color.blue] : [Color.green, Color.teal]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [Color.black, Color.gray] : [Color.blue.opacity(0.2), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.horizontal)
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
