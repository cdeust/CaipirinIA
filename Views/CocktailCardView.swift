//
//  CocktailCardView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailCardView: View {
    let cocktail: Cocktail

    var body: some View {
        VStack(alignment: .center) {
            CocktailImageView(
                url: cocktail.strDrinkThumb,
                width: UIScreen.main.bounds.width / 2 - 20,
                height: 120,
                shapeType: .roundedRectangle(cornerRadius: 10),
                accessibilityLabel: "\(cocktail.strDrink) Image"
            )

            Text(cocktail.strDrink)
                .font(.headline)
                .foregroundColor(Color("PrimaryText"))
                .padding([.top, .horizontal], 8)
                .multilineTextAlignment(.center)
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
