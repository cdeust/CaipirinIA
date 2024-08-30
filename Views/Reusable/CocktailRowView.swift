//
//  CocktailRowView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailRowView: View {
    @EnvironmentObject var appState: AppState
    var cocktail: Cocktail

    var body: some View {
        HStack(spacing: 12) {
            if let url = URL(string: cocktail.strDrinkThumb ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(cocktail.strDrink)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(cocktail.strCategory ?? "Category")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct CocktailRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCocktail = Cocktail(
            idDrink: "12345",
            strDrink: "Margarita",
            strDrinkAlternate: nil,
            strTags: nil,
            strVideo: nil,
            strCategory: "Cocktail",
            strIBA: nil,
            strAlcoholic: "Alcoholic",
            strGlass: "Cocktail glass",
            strInstructions: "Rub rim of cocktail glass with lime juice. Dip rim in coarse salt. Shake tequila, blue curacao, and lime juice with ice, strain into the salt-rimmed glass, and serve.",
            strInstructionsES: nil,
            strInstructionsDE: nil,
            strInstructionsFR: nil,
            strInstructionsIT: nil,
            strInstructionsZH_HANS: nil,
            strInstructionsZH_HANT: nil,
            strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/bry4qh1582751040.jpg",
            strIngredient1: "Tequila",
            strIngredient2: "Blue Curacao",
            strIngredient3: "Lime juice",
            strIngredient4: "Salt",
            strIngredient5: nil,
            strIngredient6: nil,
            strIngredient7: nil,
            strIngredient8: nil,
            strIngredient9: nil,
            strIngredient10: nil,
            strIngredient11: nil,
            strIngredient12: nil,
            strIngredient13: nil,
            strIngredient14: nil,
            strIngredient15: nil,
            strMeasure1: "1 1/2 oz",
            strMeasure2: "1 oz",
            strMeasure3: "1 oz",
            strMeasure4: "Coarse",
            strMeasure5: nil,
            strMeasure6: nil,
            strMeasure7: nil,
            strMeasure8: nil,
            strMeasure9: nil,
            strMeasure10: nil,
            strMeasure11: nil,
            strMeasure12: nil,
            strMeasure13: nil,
            strMeasure14: nil,
            strMeasure15: nil,
            strImageSource: nil,
            strImageAttribution: nil,
            strCreativeCommonsConfirmed: "Yes",
            dateModified: "2015-08-18 14:51:53"
        )

        Group {
            CocktailRowView(cocktail: sampleCocktail)
                .environmentObject(AppState())
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .light)

            CocktailRowView(cocktail: sampleCocktail)
                .environmentObject(AppState())
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .dark)
        }
    }
}
