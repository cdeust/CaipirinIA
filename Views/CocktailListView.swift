//
//  RecipeListView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var detectedItems: [DetectedItem]
    @State private var cocktails: [Cocktail] = []
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode

    var userEnteredIngredients: [String]
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                ErrorView(message: errorMessage)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }

            ScrollView {
                VStack(spacing: 20) {
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.top)

                    if detectedItems.isEmpty && userEnteredIngredients.isEmpty {
                        Text("No ingredients detected or entered yet.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top)
                    } else {
                        IngredientListView(
                            title: "Detected Ingredients",
                            items: detectedItems.map { $0.name },
                            confidenceValues: detectedItems.map { $0.confidence },
                            onDelete: removeDetectedItem(at:)
                        )
                        .padding(.horizontal)
                        
                        IngredientListView(
                            title: "User-Entered Ingredients",
                            items: userEnteredIngredients,
                            onDelete: nil
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }

            CocktailListViewSection(cocktails: cocktails)
                .onAppear {
                    fetchCocktails()
                }
                .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.horizontal)
        .navigationTitle("Cocktails")
    }

    private func removeDetectedItem(at index: Int) {
        detectedItems.remove(at: index)
        if detectedItems.isEmpty {
            presentationMode.wrappedValue.dismiss()  // Navigate back to the camera screen if no items left
        }
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

struct CocktailListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CocktailListView(
                detectedItems: .constant([
                    DetectedItem(name: "Lime", confidence: 0.95, boundingBox: .zero),
                    DetectedItem(name: "Mint", confidence: 0.92, boundingBox: .zero)
                ]),
                userEnteredIngredients: ["Rum", "Sugar"]
            )
            .environmentObject(AppState())
        }
    }
}
