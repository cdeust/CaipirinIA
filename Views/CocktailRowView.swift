//
//  CocktailRowView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailRowView: View {
    let cocktail: Cocktail

    var body: some View {
        HStack {
            CocktailImageView(url: cocktail.strDrinkThumb)
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(cocktail.strDrink)
                    .font(.headline)
                Text(cocktail.strCategory ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            }

            Spacer()
        }
        .padding(.vertical, 5)
    }
}
