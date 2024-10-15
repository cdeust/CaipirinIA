//
//  CocktailInfoSection.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailInfoSection: View {
    let cocktail: Cocktail

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let category = cocktail.strCategory {
                Text("Category: \(category)")
                    .font(.subheadline)
                    .foregroundColor(Color("SecondaryText"))
            }

            if let alcoholic = cocktail.strAlcoholic {
                Text("Alcoholic: \(alcoholic)")
                    .font(.subheadline)
                    .foregroundColor(Color("SecondaryText"))
            }

            if let glass = cocktail.strGlass {
                Text("Glass: \(glass)")
                    .font(.subheadline)
                    .foregroundColor(Color("SecondaryText"))
            }
        }
    }
}
