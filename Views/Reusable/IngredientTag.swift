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
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.teal.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .clipShape(Capsule()) // Pill-like shape for a modern, sleek look
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Enhanced shadow for better depth
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1) // Softer border
            )
            .accessibilityLabel(name)
            .accessibilityAddTraits(.isButton)
    }
}
