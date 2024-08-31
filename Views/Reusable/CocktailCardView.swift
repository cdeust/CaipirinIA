//
//  CocktailCardView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import SwiftUI

struct CocktailCardView: View {
    var cocktail: Cocktail

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = cocktail.strDrinkThumb {
                CocktailImageView(url: imageUrl)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.primary.opacity(0.2), radius: 5, x: 0, y: 2)
            }

            Text(cocktail.strDrink)
                .font(.headline)
                .foregroundColor(.primary)

            ForEach(cocktail.ingredients, id: \.self) { ingredient in
                Text(ingredient)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                Text(instructions)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground).opacity(0.8))
        )
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CocktailCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailCardView(cocktail: sampleCocktail)
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .preferredColorScheme(.light) // Preview in light mode

            CocktailCardView(cocktail: sampleCocktail)
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .preferredColorScheme(.dark) // Preview in dark mode
        }
    }

    static var sampleCocktail: Cocktail {
        Cocktail(
            idDrink: "1",
            strDrink: "Margarita",
            strDrinkAlternate: nil,
            strTags: "IBA,ContemporaryClassic",
            strVideo: nil,
            strCategory: "Cocktail",
            strIBA: "Contemporary Classics",
            strAlcoholic: "Alcoholic",
            strGlass: "Cocktail glass",
            strInstructions: "Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it. The salt should present to the lips of the imbiber and never mix into the drink. Shake the other ingredients with ice, then carefully pour into the glass.",
            strInstructionsES: nil,
            strInstructionsDE: nil,
            strInstructionsFR: nil,
            strInstructionsIT: nil,
            strInstructionsZH_HANS: nil,
            strInstructionsZH_HANT: nil,
            strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg",
            strIngredient1: "Tequila",
            strIngredient2: "Triple sec",
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
            strMeasure1: "1 1/2 oz ",
            strMeasure2: "1/2 oz ",
            strMeasure3: "1 oz ",
            strMeasure4: nil,
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
            strCreativeCommonsConfirmed: nil,
            dateModified: nil
        )
    }
}
