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
    var confidence: Float? = nil  // Optional confidence score
    var isMissing: Bool = false // Whether the ingredient is missing

    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .minimumScaleFactor(0.8)  // Scale down text slightly if needed
                .truncationMode(.tail)
                .foregroundColor(isMissing ? .red : .white) // Red for missing ingredients, white otherwise
            
            if let confidence = confidence {
                Text(String(format: "%.2f", confidence))
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: isMissing ? [Color.red.opacity(0.8), Color.orange.opacity(0.8)] : [Color.blue.opacity(0.8), Color.teal.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .overlay(
            Capsule()
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
        .accessibilityLabel("\(name) with confidence \(String(format: "%.2f", confidence ?? 0))")
        .accessibilityAddTraits(.isButton)
    }
}

struct IngredientTag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IngredientTag(name: "Lime", confidence: 0.95)
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .previewDisplayName("Light Mode")
                .environmentObject(AppState())
                .environment(\.colorScheme, .light)

            IngredientTag(name: "Very Long Ingredient Name That Should Truncate", confidence: 0.85)
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(UIColor.systemBackground))
                .previewDisplayName("Dark Mode")
                .environmentObject(AppState())
                .environment(\.colorScheme, .dark)
        }
    }
}
