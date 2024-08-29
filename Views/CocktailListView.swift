//
//  RecipeListView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var detectedItems: [DetectedItem]
    var userEnteredIngredients: [String]
    @State private var cocktails: [Cocktail] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                ErrorView(message: errorMessage)
            }
            
            ScrollView {
                IngredientListView(
                    title: "Detected Ingredients",
                    items: detectedItems.map { $0.name },
                    confidenceValues: detectedItems.map { $0.confidence },
                    onDelete: { index in removeDetectedItem(at: index) }
                )

                IngredientListView(
                    title: "User-Entered Ingredients",
                    items: userEnteredIngredients
                )
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()

            CocktailListViewSection(cocktails: cocktails)
                .onAppear {
                    fetchCocktails()
                }
        }
        .navigationTitle("Cocktails")
    }

    private func removeDetectedItem(at index: Int) {
        detectedItems.remove(at: index)
    }

    private func fetchCocktails() {
        let ingredientNames = detectedItems.map { $0.name } + userEnteredIngredients

        NetworkManager.fetchCocktails(withIngredients: ingredientNames) { result in
            DispatchQueue.main.async {
                handleFetchResult(result)
            }
        }
    }
    
    private func handleFetchResult(_ result: Result<[Cocktail], NetworkManager.NetworkError>) {
        switch result {
        case .success(let fetchedCocktails):
            self.cocktails = fetchedCocktails
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
