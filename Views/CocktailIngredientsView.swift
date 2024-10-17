//
//  CocktailIngredientsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailIngredientsView: View {
    let ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients:")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)

            if ingredients.isEmpty {
                Text("No ingredients available.")
                    .font(.body)
                    .foregroundColor(Color("PrimaryText"))
            } else {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text("• \(ingredient.name)")
                            .font(.body)
                            .foregroundColor(Color("PrimaryText"))
                        Spacer()
                        // Optionally, display the ingredient type or an icon representing it
                        Image(systemName: iconName(for: ingredient.type))
                            .foregroundColor(Color("PrimaryText"))
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
    
    // Helper method to get an icon name based on IngredientType
    private func iconName(for type: IngredientType) -> String {
        switch type {
        case .baseSpirit:
            return "drop.fill"
        case .modifier:
            return "square.and.pencil"
        case .sweetener:
            return "drop.fill"
        case .sour:
            return "drop.fill"
        case .bitter:
            return "drop.fill"
        case .garnish:
            return "leaf.fill"
        case .fruit:
            return "applelogo"
        case .dairy:
            return "carton.fill"
        case .mixer:
            return "sparkles"
        case .miscellaneous:
            return "ellipsis.circle.fill"
        case .other:
            return "circle.fill"
        }
    }
}
