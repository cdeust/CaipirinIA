//
//  CocktailListViewSection.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailListViewSection: View {
    @EnvironmentObject var appState: AppState
    var cocktails: [Cocktail]

    var body: some View {
        List(cocktails) { cocktail in
            NavigationLink(destination: CocktailDetailView(cocktailName: cocktail.strDrink)) {
                CocktailRowView(cocktail: cocktail)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
            }
            .listRowBackground(Color.clear) // Make list row background clear to show custom background
            .listRowInsets(EdgeInsets()) // Remove default insets for a more modern look
        }
        .listStyle(PlainListStyle()) // Use a plain list style for a clean, modern appearance
        .padding(.horizontal)
    }
}
