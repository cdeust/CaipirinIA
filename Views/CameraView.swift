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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            IngredientInputView(cocktailIngredient: $cocktailIngredient, onAdd: addCocktailIngredient)
                .padding(.horizontal)

            IngredientListView(
                title: "Ingredients List",
                items: appState.cocktailIngredients,
                onDelete: removeIngredient
            )
            .padding(.horizontal)
            .frame(maxHeight: .infinity)  // Make the list take up as much space as possible
            
            VStack(spacing: 16) {
                // NavigationLink to CameraView
                NavigationLink(destination:
                    CameraScreen(detectedItems: Binding(get: {
                        return appState.detectedItems.isEmpty ? [] : appState.detectedItems
                    }, set: { newValue in
                        appState.detectedItems = newValue
                    }))
                        .environmentObject(appState)
                ) {
                    Text("Show Camera")
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
                .padding(.horizontal)

                // NavigationLink to CocktailListView
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
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [Color.black, Color.gray] : [Color.blue.opacity(0.2), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.horizontal)
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
