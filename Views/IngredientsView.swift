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
        VStack(alignment: .leading, spacing: 0) {
            Text("Ingredients")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(Color("SecondaryText"))
                .bold()
                .padding(.bottom, 10)

            if ingredients.isEmpty {
                Text("No ingredients available.")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.vertical, 10)
            } else {
                VStack(spacing: 0) {
                    ForEach(ingredients.indices, id: \.self) { index in
                        HStack {
                            Text(ingredients[index])
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color("PrimaryText"))
                                .padding(.horizontal)

                            Spacer()

                            // You can add an optional icon or additional element here if needed
                        }
                        .frame(maxWidth: .infinity, minHeight: 44) // Set consistent height for rows
                        .background(Color.white.opacity(0.05))

                        if index != ingredients.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView(
            ingredients: [
                "Gin",
                "Tonic",
                "Lemon"
            ]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
