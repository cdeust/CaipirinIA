//
//  PreviousCocktailsList.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct PreviousCocktailsList: View {
    let cocktails: [Cocktail]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Previous Cocktails")
                .font(.headline)
                .foregroundColor(Color("PrimaryText"))
                .padding(.bottom, 5)
            
            ForEach(cocktails) { cocktail in
                HStack(spacing: 15) {
                    if let imageUrl = cocktail.strDrinkThumb, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(8)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                    }
                    
                    Text(cocktail.strDrink)
                        .font(.body)
                        .foregroundColor(Color("PrimaryText"))
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
