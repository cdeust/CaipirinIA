//
//  RecipeListView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct RecipeListView: View {
    var detectedItems: [DetectedItem]
    @State private var recipes: [Recipe] = []

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

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

            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack {
                        if let url = URL(string: "https://spoonacular.com/recipeImages/\(recipe.id)-312x231.\(recipe.imageType)") {
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
                            Text(recipe.title)
                                .font(.headline)
                            Text("Used: \(recipe.usedIngredientCount), Missed: \(recipe.missedIngredientCount)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onAppear {
                fetchRecipes()
            }
        }
        .navigationTitle("Recipes")
    }

    func fetchRecipes() {
        let ingredientNames = detectedItems.map { $0.name }
        NetworkManager.fetchRecipes(withIngredients: ingredientNames) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    self.recipes = fetchedRecipes
                case .failure(let error):
                    print("Failed to fetch recipes: \(error.localizedDescription)")
                    // Handle error as needed, e.g., show an alert
                }
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(detectedItems: [
            DetectedItem(name: "Apple", confidence: 0.5, boundingBox: CGRect(x: 0, y: 0, width: 100, height: 100)),
            DetectedItem(name: "Banana", confidence: 0.4, boundingBox: CGRect(x: 0, y: 0, width: 100, height: 100)),
            DetectedItem(name: "Carrot", confidence: 0.6, boundingBox: CGRect(x: 0, y: 0, width: 100, height: 100))
        ])
    }
}
