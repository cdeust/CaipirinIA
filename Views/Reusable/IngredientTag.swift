//
//  IngredientTag.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct IngredientTag: View {
    var name: String

    var body: some View {
        Text(name)
            .font(.subheadline)
            .padding(8)
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    IngredientTag(name: "Apple")
}
