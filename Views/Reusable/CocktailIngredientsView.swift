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
                    Image(systemName: "circle.fill") // Simple dot icon
                        .foregroundColor(.primary) // Same color for all ingredients
                        .font(.system(size: 6)) // Smaller size for a breadcrumb effect
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
