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
            if !appState.favoriteCocktails.isEmpty {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(appState.favoriteCocktails, id: \.self) { cocktail in
                        Text(cocktail)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.teal.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
            } else {
                Text("Favorite Cocktails")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text("No favorite cocktails added yet.\nNot yet linked with the filtering and generative proposition.")
                    .foregroundColor(.secondary)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
            }

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
                ShowRecipesButton(detectedItems: $appState.detectedItems)
                    .environmentObject(appState)
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
