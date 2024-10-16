//
//  DetectedItemsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct DetectedItemsView: View {
    let items: [DetectedItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(items) { ingredient in
                    IngredientTag(ingredient: ingredient)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 10)
        .transition(.opacity)
    }
}
