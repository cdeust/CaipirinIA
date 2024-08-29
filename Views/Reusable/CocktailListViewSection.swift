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
            NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                CocktailRowView(cocktail: cocktail)
            }
        }
    }
}
