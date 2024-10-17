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
        if let urlString = url, !urlString.isEmpty, let imageURL = URL(string: urlString) {
            // Proceed with loading the image from the URL
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: width, height: height)
                        .background(Color.gray.opacity(0.1))
                        .applyShape(shapeType)
                
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .applyShape(shapeType)
                        .overlay(
                            shapeOverlay()
                        )
                        .shadow(radius: 2)
                        .accessibilityLabel(Text(accessibilityLabel))
                
                case .failure:
                    // Fallback image on failure
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.6, height: height * 0.6)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                        .applyShape(shapeType)
                        .overlay(
                            shapeOverlay()
                        )
                        .shadow(radius: 2)
                        .accessibilityLabel(Text("Placeholder Image"))
                
                @unknown default:
                    // Handle any future cases
                    EmptyView()
                }
            }
        } else {
            // Placeholder Image if no URL is provided or it's empty
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.6, height: height * 0.6)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.2))
                .applyShape(shapeType)
                .overlay(
                    shapeOverlay()
                )
                .shadow(radius: 2)
                .accessibilityLabel(Text("Placeholder Image"))
        }
    }
    
    // MARK: - Helper
    
    @ViewBuilder
    private func shapeOverlay() -> some View {
        switch shapeType {
        case .circle:
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        case .roundedRectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        case .rectangle:
            Rectangle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
}

struct CocktailImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with image, circular shape
            CocktailImageView(
                url: "https://www.example.com/margarita.png",
                width: 100,
                height: 100,
                shapeType: .circle,
                accessibilityLabel: "Margarita Image"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            
            // Preview with image, rounded rectangle shape
            CocktailImageView(
                url: "https://www.example.com/old_fashioned.png",
                width: 100,
                height: 60,
                shapeType: .roundedRectangle(cornerRadius: 10),
                accessibilityLabel: "Old Fashioned Image"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            
            // Preview without image, circular shape
            CocktailImageView(
                url: nil,
                width: 100,
                height: 100,
                shapeType: .circle,
                accessibilityLabel: "Placeholder Image"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            
            // Preview without image, rounded rectangle shape
            CocktailImageView(
                url: nil,
                width: 100,
                height: 60,
                shapeType: .roundedRectangle(cornerRadius: 10),
                accessibilityLabel: "Placeholder Image"
            )
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
