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
        VStack(alignment: .leading, spacing: 0) {
            Text("Ingredients")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(Color("SecondaryText"))
                .bold()
                .padding(.bottom, 10)

            if ingredients.isEmpty {
                Text("No ingredients available.")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.vertical, 10)
            } else {
                VStack(spacing: 0) {
                    ForEach(ingredients.indices, id: \.self) { index in
                        HStack {
                            Text(ingredients[index].name)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color("PrimaryText"))
                                .padding(.horizontal)

                            Spacer()

                            // Icon representation
                            Image(systemName: iconName(for: ingredients[index].type))
                                .foregroundColor(.accentColor)
                                .imageScale(.medium)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44) // Set consistent height for rows
                        .background(Color.white.opacity(0.05))
                        
                        if index != ingredients.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
    
    // Helper method to get an icon name based on IngredientType
    private func iconName(for type: IngredientType) -> String {
        switch type {
        case .baseSpirit:
            return "drop.fill"
        case .modifier:
            return "square.and.pencil"
        case .sweetener:
            return "cube.fill"
        case .sour:
            return "lemon.fill"
        case .bitter:
            return "flame.fill"
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

struct CocktailIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailIngredientsView(
            ingredients: [
                Ingredient(name: "Gin", type: .baseSpirit),
                Ingredient(name: "Tonic", type: .mixer),
                Ingredient(name: "Lemon", type: .fruit)
            ]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
