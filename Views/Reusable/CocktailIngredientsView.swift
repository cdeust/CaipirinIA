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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
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
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.2), Color(UIColor.systemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(12)
            .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct CocktailIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailIngredientsView(ingredients: ["1 oz Tequila", "1/2 oz Blue Curacao", "1 oz Lime juice", "Salt"])
                .environmentObject(AppState())
                .preferredColorScheme(.light)

            CocktailIngredientsView(ingredients: ["1 oz Tequila", "1/2 oz Blue Curacao", "1 oz Lime juice", "Salt"])
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
}
