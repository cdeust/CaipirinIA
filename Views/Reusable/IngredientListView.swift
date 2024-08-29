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
                .font(.headline)
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
