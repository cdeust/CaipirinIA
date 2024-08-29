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
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
                .padding(.bottom, 4)

            ForEach(ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
        }
        .padding(.bottom, 16)
    }
}
