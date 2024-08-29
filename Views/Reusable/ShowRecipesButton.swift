//
//  ShowRecipesButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct ShowRecipesButton: View {
    @EnvironmentObject var appState: AppState
    @Binding var detectedItems: [DetectedItem]

    var body: some View {
        VStack {
            Spacer()
            NavigationLink(destination: CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)) {
                Text("Show Recipes")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}
