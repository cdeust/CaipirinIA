//
//  RecipeDetailView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: "https://spoonacular.com/recipeImages/\(recipe.id)-636x393.\(recipe.imageType)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                }

                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                // Ingredients Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.bottom, 4)

                    ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                        Text("• \(ingredient.original)")
                            .padding(.bottom, 2)
                    }
                }
                .padding(.bottom, 16)

                // Instructions Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.headline)
                        .padding(.bottom, 4)

                    ForEach(recipe.analyzedInstructions.flatMap { $0.steps }, id: \.number) { step in
                        Text("\(step.number). \(step.step)")
                            .padding(.bottom, 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Detail")
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(id: 1, title: "Sample Recipe", imageType: "jpg", usedIngredientCount: 2, missedIngredientCount: 3, extendedIngredients: [Ingredient(id: 1, original: "1 Apple"), Ingredient(id: 2, original: "2 Bananas")], analyzedInstructions: [Instruction(steps: [Step(number: 1, step: "Cut the apple"), Step(number: 2, step: "Peel the bananas")])]))
    }
}
