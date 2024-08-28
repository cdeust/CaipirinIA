//
//  RecipeDetailView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailDetailView: View {
    var cocktail: Cocktail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Display the cocktail image
                if let url = URL(string: "https://spoonacular.com/cocktailImages/\(cocktail.id)-636x393.\(cocktail.image)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                }

                // Display the cocktail title
                Text(cocktail.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                // Ingredients Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.bottom, 4)

                    ForEach(cocktail.extendedIngredients) { ingredient in
                        Text("• \(ingredient.name): \(String(format: "%.2f", ingredient.amount)) \(ingredient.original)")
                            .padding(.bottom, 2)
                    }
                }
                .padding(.bottom, 16)

                // Instructions Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.headline)
                        .padding(.bottom, 4)

                    Text(cocktail.instructions)
                        .padding(.bottom, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Cocktail Detail")
    }
}
