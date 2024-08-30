//
//  IngredientInputView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct IngredientInputView: View {
    @EnvironmentObject var appState: AppState
    @Binding var cocktailIngredient: String
    var onAdd: () -> Void

    var body: some View {
        Section(header: Text("Cocktail Ingredients")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top, 8)) {
            HStack {
                TextField("Enter cocktail ingredients", text: $cocktailIngredient)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.secondarySystemBackground)) // Adaptive background color
                            .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                Button(action: onAdd) {
                    Text("Add")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.teal, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.primary.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .disabled(cocktailIngredient.isEmpty)
                .opacity(cocktailIngredient.isEmpty ? 0.5 : 1.0) // Slight transparency when disabled
            }
            .padding(.horizontal)
        }
    }
}

struct IngredientInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IngredientInputView(cocktailIngredient: .constant(""), onAdd: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .environmentObject(AppState())
                .environment(\.colorScheme, .light)

            IngredientInputView(cocktailIngredient: .constant("Mint"), onAdd: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .environmentObject(AppState())
                .environment(\.colorScheme, .dark)
        }
    }
}
