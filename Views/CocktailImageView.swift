//
//  CocktailImageView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailImageView: View {
    let url: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    var shapeType: ShapeType = .rectangle
    var accessibilityLabel: String = "Cocktail Image"
    
    var body: some View {
        ZStack {
            // Background for loading/empty states
            RoundedRectangle(cornerRadius: cornerRadius())
                .fill(Color.gray.opacity(0.1))
                .frame(width: width, height: height)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

            if let urlString = url, !urlString.isEmpty, let imageURL = URL(string: urlString) {
                // Proceed with loading the image from the URL
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder while loading
                        ProgressView()
                            .frame(width: width, height: height)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius()))
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius()))
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .accessibilityLabel(Text(accessibilityLabel))
                        
                    case .failure:
                        // Fallback image on failure
                        placeholderImage()
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Placeholder Image if no URL is provided or it's empty
                placeholderImage()
            }
        }
    }
    
    // MARK: - Helper: Placeholder Image
    private func placeholderImage() -> some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.6, height: height * 0.6)
            .foregroundColor(.gray)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius()))
            .accessibilityLabel(Text("Placeholder Image"))
    }
    
    // Helper to determine corner radius based on shape type
    private func cornerRadius() -> CGFloat {
        switch shapeType {
        case .circle:
            return min(width, height) / 2
        case .roundedRectangle(let cornerRadius):
            return cornerRadius
        case .rectangle:
            return 0
        }
    }
}
