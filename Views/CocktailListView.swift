//
//  RecipeListView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailListView: View {
    var detectedItems: [DetectedItem]
    var userEnteredIngredients: [String]
    @State private var cocktails: [Cocktail] = []
    @State private var errorMessage: String?

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                ErrorView(message: errorMessage)
            }
            
            ScrollView {
                VStack {
                    IngredientGridView(items: detectedItems.map { $0.name },
                                       confidenceValues: detectedItems.map { Double($0.confidence) })
                    
                    IngredientGridView(items: userEnteredIngredients)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()

            CocktailListViewSection(cocktails: cocktails)
                .onAppear(perform: fetchCocktails)
        }
        .navigationTitle("Cocktails")
    }

    private func fetchCocktails() {
        let ingredientNames = detectedItems.map { $0.name } + userEnteredIngredients

        NetworkManager.fetchCocktails(withIngredients: ingredientNames) { result in
            DispatchQueue.main.async {
                handleFetchResult(result)
            }
        }
    }

    private func handleFetchResult(_ result: Result<[Cocktail], NetworkManager.NetworkError>) {
        switch result {
        case .success(let fetchedCocktails):
            self.cocktails = fetchedCocktails
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .padding()
    }
}

struct IngredientGridView: View {
    var items: [String]
    var confidenceValues: [Double]? = nil

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                IngredientTag(name: items[index])
                    .overlay(
                        confidenceOverlay(for: index),
                        alignment: .topTrailing
                    )
            }
        }
        .padding()
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

struct CocktailListViewSection: View {
    var cocktails: [Cocktail]

    var body: some View {
        List(cocktails) { cocktail in
            NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                CocktailRowView(cocktail: cocktail)
            }
        }
    }
}

struct CocktailRowView: View {
    var cocktail: Cocktail

    var body: some View {
        HStack {
            if let url = URL(string: cocktail.strDrinkThumb) {
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
                Text(cocktail.strDrink)
                    .font(.headline)
            }
        }
    }
}
