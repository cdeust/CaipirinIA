//
//  IngredientListView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct IngredientListView: View {
    @EnvironmentObject var appState: AppState
    let title: String
    let items: [String]
    var confidenceValues: [Float]? = nil
    var onDelete: ((Int) -> Void)? = nil

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.top)

            if items.isEmpty {
                Text("No ingredients added yet.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
            } else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            IngredientTag(name: items[index])
                            if let onDelete = onDelete {
                                Button(action: {
                                    onDelete(index)
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .overlay(
                            confidenceOverlay(for: index),
                            alignment: .topTrailing
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 16)
        .background(Color(UIColor.systemBackground)) // Background adapts to light/dark mode
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2) // Adaptive shadow
    }

    @ViewBuilder
    private func confidenceOverlay(for index: Int) -> some View {
        if let confidenceValues = confidenceValues {
            Text(String(format: "Conf: %.2f", confidenceValues[index]))
                .font(.caption)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.black.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .offset(y: -10)
        } else {
            EmptyView()
        }
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IngredientListView(
                title: "Detected Ingredients",
                items: ["Tequila", "Lime", "Mint"],
                confidenceValues: [0.95, 0.85, 0.75],
                onDelete: nil
            )
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .light)

            IngredientListView(
                title: "Detected Ingredients",
                items: ["Tequila", "Lime", "Mint"],
                confidenceValues: [0.95, 0.85, 0.75],
                onDelete: nil
            )
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .dark)
        }
    }
}
