//
//  CocktailIngredientsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailIngredientsView: View {
    @EnvironmentObject var appState: AppState
    var ingredients: [String]
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(ingredients, id: \.self) { ingredient in
                HStack {
                    Image(systemName: icon(for: ingredient))
                        .foregroundColor(color(for: ingredient))
                        .font(.system(size: 16))
                    Text(ingredient)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray5).opacity(0.8))
        )
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity)
    }

    // Determine the appropriate icon based on the ingredient
    private func icon(for ingredient: String) -> String {
        let lowercasedIngredient = ingredient.lowercased()
        if lowercasedIngredient.contains("lime") || lowercasedIngredient.contains("lemon") || lowercasedIngredient.contains("juice") {
            return "hourglass.bottomhalf.filled"
        } else if lowercasedIngredient.contains("sugar") {
            return "cube.box.fill"
        } else if lowercasedIngredient.contains("salt") || lowercasedIngredient.contains("ice") {
            return "cube.fill"
        } else {
            return "hourglass.bottomhalf.filled"
        }
    }

    // Determine the color based on the ingredient type
    private func color(for ingredient: String) -> Color {
        let lowercasedIngredient = ingredient.lowercased()
        if lowercasedIngredient.contains("lime") || lowercasedIngredient.contains("lemon") || lowercasedIngredient.contains("juice") {
            return .yellow
        } else if lowercasedIngredient.contains("syrup") || lowercasedIngredient.contains("sugar") {
            return .orange
        } else if lowercasedIngredient.contains("salt") {
            return .gray
        } else {
            return .white
        }
    }
}

struct CocktailIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailIngredientsView(ingredients: ["1 oz Tequila", "1/2 oz Simple Syrup", "1 oz Lime juice", "Salt"])
                .environmentObject(AppState())
                .preferredColorScheme(.light)

            CocktailIngredientsView(ingredients: ["1 oz Tequila", "1/2 oz Simple Syrup", "1 oz Lime juice", "Salt"])
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
}
