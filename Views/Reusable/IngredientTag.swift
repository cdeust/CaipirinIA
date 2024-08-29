//
//  IngredientTag.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct IngredientTag: View {
    @EnvironmentObject var appState: AppState
    var name: String

    var body: some View {
        Text(name)
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .clipShape(Capsule()) // Use Capsule for a pill-like shape
            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
            .accessibilityLabel(name)
            .accessibilityAddTraits(.isButton)
    }
}
