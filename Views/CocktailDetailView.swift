//
//  RecipeDetailView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailDetailView: View {
    @EnvironmentObject var appState: AppState
    var cocktail: Cocktail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
            }
            .padding()
        }
        .navigationTitle("Cocktail Detail")
    }
}
