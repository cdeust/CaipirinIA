//
//  CocktailImageView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailImageView: View {
    @EnvironmentObject var appState: AppState
    var url: String?
    var placeholderImage: Image = Image(systemName: "photo")
    
    var body: some View {
        if let url = URL(string: url ?? "") {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                case .failure:
                    placeholderImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            placeholderImage
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
        }
    }
}
