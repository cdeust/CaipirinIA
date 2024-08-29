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
        Section(header: Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        ) {
            if items.isEmpty {
                Text(emptyMessage)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
            } else {
                List(items, id: \.self) { item in
                    Text(item)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}
