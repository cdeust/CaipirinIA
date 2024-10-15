//
//  CocktailGridView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailGridView: View {
    let cocktails: [Cocktail]
    let columns: [GridItem]
    let navigateToDetail: (Cocktail) -> CocktailDetailView

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(cocktails) { cocktail in
                    NavigationLink(destination: navigateToDetail(cocktail)) {
                        CocktailCardView(cocktail: cocktail)
                            .frame(height: 200)
                    }
                    .accessibilityLabel(Text("View details for \(cocktail.strDrink)"))
                }
            }
            .padding()
        }
    }
}
