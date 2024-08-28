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
                // Cocktail Image
                if let url = URL(string: cocktail.strDrinkThumb) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }

                // Cocktail Title
                Text(cocktail.strDrink)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                // Ingredients Section
                if !cocktail.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.bottom, 4)

                        ForEach(cocktail.ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                    }
                    .padding(.bottom, 16)
                }

                // Instructions Section
                if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions")
                            .font(.headline)
                            .padding(.bottom, 4)

                        Text(instructions)
                    }
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
