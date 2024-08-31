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
    var missingItems: [String] = []  // Pass the missing items here
    var onDelete: ((Int) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.top)

            ScrollView {  // ScrollView to handle long lists
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], alignment: .leading, spacing: 10) {
                    // Show available ingredients
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            IngredientTag(name: items[index], confidence: confidenceValues?.indices.contains(index) == true ? confidenceValues?[index] : nil)
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
                    }
                    // Display missing ingredients in red
                    ForEach(missingItems, id: \.self) { missingItem in
                        IngredientTag(name: missingItem, isMissing: true)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 16)
        .frame(maxHeight: .infinity)  // Make the list take up all available vertical space
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
