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
        Section(header: Text(title)) {
            if items.isEmpty {
                Text(emptyMessage)
                    .foregroundColor(.secondary)
            } else {
                List(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}
