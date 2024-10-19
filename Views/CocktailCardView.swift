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
        VStack(alignment: .center, spacing: 8) {
            // Full-width rectangular image with softer shadows
            CocktailImageView(
                url: cocktail.strDrinkThumb,
                width: UIScreen.main.bounds.width / 2 - 30,
                height: 180,
                shapeType: .roundedRectangle(cornerRadius: 12),
                accessibilityLabel: "\(cocktail.strDrink) Image"
            )
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)

            // Name of the cocktail with consistent padding and scaling
            Text(cocktail.strDrink)
                .font(.system(.headline, design: .rounded))  // Rounded, system font for clean readability
                .foregroundColor(Color("PrimaryText"))
                .frame(maxWidth: .infinity, minHeight: 40)  // Ensure consistent height
                .padding(.horizontal, 12)  // Adjust horizontal padding for a sleeker look
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)  // Softer shadow around the card
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.08), lineWidth: 0.6)  // Thinner, more subtle border
        )
        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 230)  // Ensure consistent size for all cards
        .padding(.vertical, 8)
    }
}
