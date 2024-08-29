//
//  RecipeDetailView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailDetailView: View {
    @EnvironmentObject var appState: AppState
    @State private var cocktail: Cocktail?
    @State private var errorMessage: String?
    
    let cocktailName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let cocktail = cocktail {
                    CocktailImageView(url: cocktail.strDrinkThumb)
                    
                    CocktailTitleView(title: cocktail.strDrink)
                    
                    if !cocktail.ingredients.isEmpty {
                        CocktailIngredientsView(ingredients: cocktail.ingredients)
                    }
                    
                    if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                        CocktailInstructionsView(instructions: instructions)
                    } else {
                        Text("No instructions available.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding()
            .navigationTitle("Cocktail Detail")
            .onAppear(perform: fetchCocktailDetails)
        }
    }

    private func fetchCocktailDetails() {
        NetworkManager.fetchCocktailDetails(forCocktailName: cocktailName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cocktails):
                    self.cocktail = cocktails.first
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CocktailDetailView(cocktailName: "Margarita")
                .environmentObject(AppState())
        }
    }
}
