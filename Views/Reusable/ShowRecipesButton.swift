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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let isButtonDisabled = detectedItems.isEmpty && appState.cocktailIngredients.isEmpty

        NavigationLink(
            destination: CocktailListView(detectedItems: $detectedItems, userEnteredIngredients: appState.cocktailIngredients)
                .environmentObject(appState)
        ) {
            Text("Show All Recipes")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colorScheme == .dark ? [Color.green, Color.blue] : [Color.green, Color.teal]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .disabled(isButtonDisabled)
        .opacity(isButtonDisabled ? 0.5 : 1.0) // Adjust opacity based on availability of ingredients
        .padding(.bottom, 16)
        .onChange(of: detectedItems) { newValue in
            print("ShowRecipesButton - Detected Items Changed: \(newValue.count)")
        }
    }
}

struct ShowRecipesButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with ingredients (Button enabled)
            ShowRecipesButton(detectedItems: .constant([DetectedItem(name: "Lime", confidence: 0.95, boundingBox: .zero)]))
                .environmentObject(AppState())
                .previewDisplayName("Button Enabled")
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()

            // Preview without ingredients (Button disabled)
            ShowRecipesButton(detectedItems: .constant([]))
                .environmentObject(AppState())
                .previewDisplayName("Button Disabled")
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()

            // Preview with ingredients in dark mode (Button enabled)
            ShowRecipesButton(detectedItems: .constant([DetectedItem(name: "Lime", confidence: 0.95, boundingBox: .zero)]))
                .environmentObject(AppState())
                .previewDisplayName("Button Enabled - Dark Mode")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()

            // Preview without ingredients in dark mode (Button disabled)
            ShowRecipesButton(detectedItems: .constant([]))
                .environmentObject(AppState())
                .previewDisplayName("Button Disabled - Dark Mode")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
