//
//  GeneratedCocktailDetailView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import SwiftUI

struct GeneratedCocktailDetailView: View {
    let cocktail: Cocktail?
    let preparation: Preparation?
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            if cocktail != nil || preparation != nil {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Image Section
                        CocktailImageView(
                            url: cocktail?.strDrinkThumb ?? preparation?.strDrinkThumb,
                            width: UIScreen.main.bounds.size.width,
                            height: 180,
                            accessibilityLabel: cocktail?.strDrink ?? preparation?.cocktailName ?? "Cocktail Image"
                        )
                        .applyShape(.rectangle)
                        
                        // Cocktail Name Section
                        Text(cocktail?.strDrink ?? preparation?.cocktailName ?? "No Name Available")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Cocktail Info Section
                        CocktailInfoSection(category: cleanText(cocktail?.strCategory ?? preparation?.strCategory),
                            alcoholic: cleanText(cocktail?.strAlcoholic ?? preparation?.strAlcoholic),
                            glass: cleanText(cocktail?.strGlass ?? preparation?.strGlass))
                        
                        // Ingredients Section
                        if let ingredients = getValidIngredients() {
                            IngredientsView(ingredients: ingredients)
                        } else {
                            Text("No ingredients available.")
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                                .padding(.horizontal)
                        }
                        
                        // Instructions Section
                        InstructionsView(instructions: cleanText(cocktail?.strInstructions ?? preparation?.strInstructions))
                        
                        // Prepare Button
                        if let cocktail = cocktail {
                            PrepareButton(cocktail: cocktail)
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                }
                .navigationTitle(cocktail?.strDrink ?? preparation?.cocktailName ?? "Cocktail")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                // Show loading view if cocktail or preparation are not available
                ProgressView("Loading...")
            }
        }
    }
    
    private func ingredientSection(_ ingredients: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients:")
                .font(.headline)

            ForEach(ingredients, id: \.self) { ingredient in
                Text("• \(ingredient)")
                    .padding(.leading)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
    }
    
    private var prepareButton: some View {
        if cocktail != nil {
            return AnyView(
                NavigationLink(destination: PreparationStepsView(cocktail: cocktail!)) {
                    Text("Prepare")
                        .font(.headline)
                        .foregroundColor(Color("PrimaryText"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("BackgroundStart"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                    .padding(.horizontal, 20)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // MARK: - Helper Functions
    
    // Function to get valid ingredients from either cocktail or preparation
    private func getValidIngredients() -> [String]? {
        // First, gather all the ingredients from the cocktail object
        let cocktailIngredients: [String?] = [
            cocktail?.strIngredient1, cocktail?.strIngredient2, cocktail?.strIngredient3,
            cocktail?.strIngredient4, cocktail?.strIngredient5, cocktail?.strIngredient6,
            cocktail?.strIngredient7, cocktail?.strIngredient8, cocktail?.strIngredient9,
            cocktail?.strIngredient10, cocktail?.strIngredient11, cocktail?.strIngredient12,
            cocktail?.strIngredient13, cocktail?.strIngredient14, cocktail?.strIngredient15
        ]
        
        // Then, gather all the ingredients from the preparation object
        let preparationIngredients: [String?] = [
            preparation?.strIngredient1, preparation?.strIngredient2, preparation?.strIngredient3,
            preparation?.strIngredient4, preparation?.strIngredient5, preparation?.strIngredient6,
            preparation?.strIngredient7, preparation?.strIngredient8, preparation?.strIngredient9,
            preparation?.strIngredient10
        ]
        
        // Combine both lists and choose the first non-nil value for each corresponding index
        let ingredients = zip(cocktailIngredients, preparationIngredients).map { cocktailIng, prepIng in
            cocktailIng ?? prepIng
        }
        
        // Use compactMap and cleanText to ensure valid ingredients
        return ingredients.compactMap { ingredient in
            return cleanText(ingredient)
        }.filter { !$0.isEmpty }
    }
    
    // Function to clean the text and avoid JSON-like artifacts
    private func cleanText(_ text: String?) -> String? {
        guard let text = text else { return nil }
        return text.replacingOccurrences(of: "\"text\":", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
