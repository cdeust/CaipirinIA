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
    @State private var generatedCocktails: [Cocktail] = []
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode

    var userEnteredIngredients: [String]
    
    var body: some View {
        VStack { // Reduced spacing between all elements
            if let errorMessage = errorMessage {
                ErrorView(message: errorMessage)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            ScrollView {
                VStack(spacing: 5) {  // Reduced spacing between rows
                    if detectedItems.isEmpty && userEnteredIngredients.isEmpty {
                        Text("No ingredients detected or entered yet.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top)
                    } else {
                        let availableIngredients = detectedItems.map { $0.name } + userEnteredIngredients
                        let missingIngredients = determineMissingIngredients(from: availableIngredients)

                        IngredientListView(
                            title: "Detected & Entered Ingredients",
                            items: availableIngredients,
                            confidenceValues: detectedItems.map { $0.confidence },
                            missingItems: missingIngredients,
                            onDelete: removeDetectedItem(at:)
                        )
                        .padding(.horizontal)
                        .frame(maxHeight: 200)  // Limit the height of the ingredient list
                    }
                }
                
                // Display both generated and fetched cocktails
                if !cocktails.isEmpty || !generatedCocktails.isEmpty {
                    VStack(spacing: 8) {  // Reduced spacing between rows
                        ForEach(generatedCocktails + cocktails, id: \.id) { cocktail in
                            NavigationLink(destination: CocktailDetailView(cocktailName: cocktail.strDrink)) {
                                CocktailRowView(cocktail: cocktail)
                                    .padding(.vertical, 6)  // Reduced padding for a more compact view
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .padding(.horizontal)
                } else if cocktails.isEmpty && generatedCocktails.isEmpty {
                    Text("No cocktails found or generated.")
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
            }
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
        .onAppear {
            fetchAndGenerateCocktails()
        }
    }

    private func determineMissingIngredients(from availableIngredients: [String]) -> [String] {
        let allIngredientNames = ingredientsCatalog.map { $0.name }
        return allIngredientNames.filter { !availableIngredients.contains($0) }
    }

    private func removeDetectedItem(at index: Int) {
        detectedItems.remove(at: index)
        if detectedItems.isEmpty {
            presentationMode.wrappedValue.dismiss()  // Navigate back to the camera screen if no items left
        }
    }

    private func fetchAndGenerateCocktails() {
        let ingredientNames = detectedItems.map { $0.name } + userEnteredIngredients
        
        // Generate custom cocktails based on the ingredients
        let cocktailGenerator = CocktailGenerator()
        self.generatedCocktails = cocktailGenerator.generateCocktails(fromDetected: ingredientNames)
        
        // Fetch cocktails from CocktailDB
        fetchCocktails(from: ingredientNames)
    }

    private func fetchCocktails(from ingredients: [String]) {
        NetworkManager.fetchCocktails(withIngredients: ingredients) { result in
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
