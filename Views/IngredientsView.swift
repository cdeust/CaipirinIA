//
//  IngredientsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 18/10/2024.
//

import SwiftUI

struct IngredientsView: View {
    let ingredients: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients:")
                .font(.headline)
            
            ForEach(ingredients, id: \.self) { ingredient in
                Text("• \(ingredient)")
                    .padding(.leading)
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            }
        }
        .padding(.horizontal)
    }
}
