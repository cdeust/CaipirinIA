//
//  CocktailGridView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailGridView: View {
    let cocktails: [Cocktail]
    let navigateToDetail: (Cocktail) -> CocktailDetailView
    
    // Dynamic columns for grid layout
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {  // Increased spacing for a more refined look
                ForEach(cocktails) { cocktail in
                    NavigationLink(destination: navigateToDetail(cocktail)) {
                        CocktailCardView(cocktail: cocktail)
                            .frame(height: 250)  // Consistent height for all cards
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)  // Enhanced shadow
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.9))  // Light background for each card
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())  // Remove default button styling
                    .accessibilityLabel(Text("View details for \(cocktail.strDrink)"))
                }
            }
            .padding(.horizontal, 16)  // Padding around the grid
            .padding(.top, 20)         // Top padding for visual separation from navigation bar
        }
        .background(Color("BackgroundEnd").edgesIgnoringSafeArea(.all))  // Matches the overall theme
        .navigationTitle("Cocktails")
        .navigationBarTitleDisplayMode(.inline)
    }
}
