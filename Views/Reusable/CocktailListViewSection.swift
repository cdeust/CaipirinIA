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
            }
            .listRowSeparator(.hidden) // Hide the separator for each row
            .listRowBackground(Color.clear) // Make list row background clear to show custom background
            .listRowInsets(EdgeInsets()) // Remove default insets for a more modern look
        }
        .listStyle(PlainListStyle()) // Use a plain list style for a clean, modern appearance
        .background(Color.clear) // Ensure the list background blends with the view's background
        .padding(.horizontal)
    }
}

struct CocktailListViewSection_Previews: PreviewProvider {
    static var previews: some View {
        CocktailListViewSection(
            cocktails: [
                Cocktail(idDrink: "1", strDrink: "Margarita", strDrinkAlternate: nil, strTags: nil, strVideo: nil, strCategory: "Cocktail", strIBA: nil, strAlcoholic: "Alcoholic", strGlass: "Cocktail glass", strInstructions: "Shake ingredients with ice and strain into glass.", strInstructionsES: nil, strInstructionsDE: nil, strInstructionsFR: nil, strInstructionsIT: nil, strInstructionsZH_HANS: nil, strInstructionsZH_HANT: nil, strDrinkThumb: nil, strIngredient1: "Tequila", strIngredient2: "Triple sec", strIngredient3: "Lime juice", strIngredient4: nil, strIngredient5: nil, strIngredient6: nil, strIngredient7: nil, strIngredient8: nil, strIngredient9: nil, strIngredient10: nil, strIngredient11: nil, strIngredient12: nil, strIngredient13: nil, strIngredient14: nil, strIngredient15: nil, strMeasure1: "1 1/2 oz", strMeasure2: "1 oz", strMeasure3: "1/2 oz", strMeasure4: nil, strMeasure5: nil, strMeasure6: nil, strMeasure7: nil, strMeasure8: nil, strMeasure9: nil, strMeasure10: nil, strMeasure11: nil, strMeasure12: nil, strMeasure13: nil, strMeasure14: nil, strMeasure15: nil, strImageSource: nil, strImageAttribution: nil, strCreativeCommonsConfirmed: nil, dateModified: nil)
            ]
        )
        .environmentObject(AppState())
    }
}
