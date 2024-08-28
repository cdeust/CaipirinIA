//
//  RecipeListView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailListView: View {
    var detectedItems: [DetectedItem]
    @State private var cocktails: [Cocktail] = []

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(detectedItems, id: \.id) { item in
                        IngredientTag(name: item.name)
                            .overlay(
                                Text(String(format: "Conf: %.2f", item.confidence))
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .offset(y: -10),
                                alignment: .topTrailing
                            )
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()

            List(cocktails) { cocktail in
                NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                    HStack {
                        if let url = URL(string: cocktail.image) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(cocktail.title)
                                .font(.headline)
                            Text("Ingredients: \(cocktail.extendedIngredients.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onAppear {
                fetchCocktails()
            }
        }
        .navigationTitle("Cocktails")
    }

    func fetchCocktails() {
        let ingredientNames = detectedItems.map { $0.name }
        NetworkManager.fetchCocktails(withIngredients: ingredientNames) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCocktails):
                    self.cocktails = fetchedCocktails
                case .failure(let error):
                    print("Failed to fetch cocktails: \(error.localizedDescription)")
                    // Handle error as needed, e.g., show an alert
                }
            }
        }
    }
}
