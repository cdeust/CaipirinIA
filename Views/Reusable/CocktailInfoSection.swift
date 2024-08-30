//
//  CocktailInfoSection.swift
//  CaipirinIA
//
//  Created by Clément Deust on 30/08/2024.
//

import SwiftUI

struct CocktailInfoSection: View {
    var cocktail: Cocktail

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let category = cocktail.strCategory {
                HStack {
                    Text("Category:")
                        .fontWeight(.bold)
                    Text(category)
                    Spacer()  // Ensure the section takes up full width
                }
            }

            if let alcoholic = cocktail.strAlcoholic {
                HStack {
                    Text("Alcoholic:")
                        .fontWeight(.bold)
                    Text(alcoholic)
                    Spacer()
                }
            }

            if let glass = cocktail.strGlass {
                HStack {
                    Text("Glass:")
                        .fontWeight(.bold)
                    Text(glass)
                    Spacer()
                }
            }

            if let iba = cocktail.strIBA {
                HStack {
                    Text("IBA:")
                        .fontWeight(.bold)
                    Text(iba)
                    Spacer()
                }
            }

            if let tags = cocktail.strTags {
                HStack {
                    Text("Tags:")
                        .fontWeight(.bold)
                    Text(tags)
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray5).opacity(0.8))
        )
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity)  // Ensure the background takes up the full width
    }
}

struct CocktailInfoSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode Preview
            CocktailInfoSection(
                cocktail: Cocktail(
                    idDrink: "1",
                    strDrink: "Margarita",
                    strDrinkAlternate: nil,
                    strTags: "IBA",
                    strVideo: nil,
                    strCategory: "Cocktail",
                    strIBA: "Contemporary Classics",
                    strAlcoholic: "Alcoholic",
                    strGlass: "Cocktail glass",
                    strInstructions: "Shake and strain into a chilled cocktail glass.",
                    strInstructionsES: nil,
                    strInstructionsDE: nil,
                    strInstructionsFR: nil,
                    strInstructionsIT: nil,
                    strInstructionsZH_HANS: nil,
                    strInstructionsZH_HANT: nil,
                    strDrinkThumb: nil,
                    strIngredient1: "Tequila",
                    strIngredient2: "Triple sec",
                    strIngredient3: "Lime juice",
                    strIngredient4: nil,
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
                    strMeasure3: "1/2 oz",
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
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light Mode")
            
            // Dark Mode Preview
            CocktailInfoSection(
                cocktail: Cocktail(
                    idDrink: "1",
                    strDrink: "Margarita",
                    strDrinkAlternate: nil,
                    strTags: "IBA",
                    strVideo: nil,
                    strCategory: "Cocktail",
                    strIBA: "Contemporary Classics",
                    strAlcoholic: "Alcoholic",
                    strGlass: "Cocktail glass",
                    strInstructions: "Shake and strain into a chilled cocktail glass.",
                    strInstructionsES: nil,
                    strInstructionsDE: nil,
                    strInstructionsFR: nil,
                    strInstructionsIT: nil,
                    strInstructionsZH_HANS: nil,
                    strInstructionsZH_HANT: nil,
                    strDrinkThumb: nil,
                    strIngredient1: "Tequila",
                    strIngredient2: "Triple sec",
                    strIngredient3: "Lime juice",
                    strIngredient4: nil,
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
                    strMeasure3: "1/2 oz",
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
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
