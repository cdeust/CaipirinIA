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
            HStack {
                ForEach(items) { item in
                    IngredientTag(name: item.name)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
    }
}
