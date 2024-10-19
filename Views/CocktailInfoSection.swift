//
//  CocktailInfoSection.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailInfoSection: View {
    let category: String?
    let alcoholic: String?
    let glass: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category
            InfoRow(title: "Category", value: category ?? "No category available")
            
            // Alcoholic or Non-Alcoholic
            InfoRow(title: "Alcoholic", value: alcoholic ?? "No alcoholic available")
            
            // Glass type
            InfoRow(title: "Glass", value: glass ?? "No glass available")
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(Color("PrimaryText"))
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundColor(Color("PrimaryText").opacity(0.9))
        }
    }
}

struct CocktailInfoSection_Previews: PreviewProvider {
    static var previews: some View {
        CocktailInfoSection(category: "Cocktail", alcoholic: "Alcoholic", glass: "Martini Glass")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
