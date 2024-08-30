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
        ZStack {
            if let url = URL(string: url ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemBackground))
                            )
                            .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                    case .failure:
                        placeholderImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .foregroundColor(.gray)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemBackground))
                            )
                            .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholderImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .foregroundColor(.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemBackground))
                    )
                    .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }
}

struct CocktailImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailImageView(url: "https://www.example.com/image.jpg")
                .environmentObject(AppState())
                .preferredColorScheme(.light)

            CocktailImageView(url: "https://www.example.com/image.jpg")
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
}
