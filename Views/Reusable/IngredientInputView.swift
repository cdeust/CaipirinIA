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
        Section(header: Text("Cocktail Ingredients")) {
            HStack {
                TextField("Enter cocktail ingredients", text: $cocktailIngredient)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: onAdd) {
                    Text("Add")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(cocktailIngredient.isEmpty)
            }
        }
    }
}
