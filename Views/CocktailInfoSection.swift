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
        VStack(alignment: .leading, spacing: 8) {
            if let category = category {
                Text("Category: \(category)")
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            } else {
                Text("Category: No category available")
            }

            if let alcoholic = alcoholic {
                Text("Alcoholic: \(alcoholic)")
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            } else {
                Text("Alcoholic: No alcoholic available")
            }

            if let glass = glass {
                Text("Glass: \(glass)")
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            } else {
                Text("Glass: No glass available")
            }
        }
        .padding(.horizontal)
    }
}
