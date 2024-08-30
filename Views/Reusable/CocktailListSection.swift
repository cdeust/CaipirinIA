//
//  CocktailListSection.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailListSection: View {
    @EnvironmentObject var appState: AppState
    var title: String
    var items: [String]
    var emptyMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.vertical, 4)

            if items.isEmpty {
                Text(emptyMessage)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
                    .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
            } else {
                List(items, id: \.self) { item in
                    Text(item)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear) // Background clear to blend with the view
                .cornerRadius(8)
                .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }
}

struct CocktailListSection_Previews: PreviewProvider {
    static var previews: some View {
        CocktailListSection(
            title: "Favorite Cocktails",
            items: ["Margarita", "Mojito", "Old Fashioned"],
            emptyMessage: "No favorite cocktails added yet."
        )
        .environmentObject(AppState())
    }
}
