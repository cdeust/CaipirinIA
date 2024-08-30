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
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
            )
            .lineLimit(1)  // Ensure text stays on one line
            .minimumScaleFactor(0.5)  // Scale down text if too long
            .truncationMode(.tail)  // Add ellipsis if text is too long
            .frame(maxWidth: .infinity, alignment: .leading)  // Use available width while staying on one line
            .accessibilityLabel(name)
            .accessibilityAddTraits(.isButton)
            .background(
                Color(UIColor.systemBackground) // Ensure background adapts to light/dark mode
                    .clipShape(Capsule())
            )
    }
}

struct IngredientTag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IngredientTag(name: "Lime")
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .previewDisplayName("Light Mode")
                .environmentObject(AppState())
                .environment(\.colorScheme, .light)

            IngredientTag(name: "Very Long Ingredient Name That Should Truncate")
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .previewDisplayName("Dark Mode")
                .environmentObject(AppState())
                .environment(\.colorScheme, .dark)
        }
    }
}
