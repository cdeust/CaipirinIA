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
            NavigationLink(
                destination: CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)
            ) {
                Text("Show Recipes")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.primary.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal)
    }
}

struct ShowRecipesButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShowRecipesButton(detectedItems: .constant([]))
                .environmentObject(AppState())
                .preferredColorScheme(.light)

            ShowRecipesButton(detectedItems: .constant([]))
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
}
