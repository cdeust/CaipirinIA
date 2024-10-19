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
                            height: 250,
                            shapeType: .roundedRectangle(cornerRadius: 15)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)

                        // Cocktail Name Section
                        Text(cocktail?.strDrink ?? preparation?.cocktailName ?? "No Name Available")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(Color("SecondaryText"))

                        // Cocktail Info Section
                        CocktailInfoSection(category: cleanText(cocktail?.strCategory ?? preparation?.strCategory),
                            alcoholic: cleanText(cocktail?.strAlcoholic ?? preparation?.strAlcoholic),
                            glass: cleanText(cocktail?.strGlass ?? preparation?.strGlass))
                                .padding(.horizontal)
                        // Ingredients Section
                        if let ingredients = getValidIngredients() {
                            IngredientsView(ingredients: ingredients)
                        } else {
                            Text("No ingredients available.")
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                        }

                        // Instructions Section
                        InstructionsView(instructions: cleanText(cocktail?.strInstructions ?? preparation?.strInstructions))

                        // Prepare Button
                        if let cocktail = cocktail {
                            PrepareButton(cocktail: cocktail)
                                .padding(.horizontal)
                        }

                        Spacer()
                    }
                    .padding(.top)
                }
                .navigationTitle(cocktail?.strDrink ?? preparation?.cocktailName ?? "Cocktail")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(cocktail?.strDrink ?? preparation?.cocktailName ?? "Cocktail")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.accentColor)
                    }
                }
            } else {
                // Show loading view if cocktail or preparation are not available
                ProgressView("Loading...")
                    .padding()
            }
        }
    }
    
    // Helper Functions for Ingredients and Clean Text
    private func getValidIngredients() -> [String]? {
        let cocktailIngredients: [String?] = [
            cocktail?.strIngredient1, cocktail?.strIngredient2, cocktail?.strIngredient3,
            cocktail?.strIngredient4, cocktail?.strIngredient5, cocktail?.strIngredient6,
            cocktail?.strIngredient7, cocktail?.strIngredient8, cocktail?.strIngredient9,
            cocktail?.strIngredient10
        ]
        
        let preparationIngredients: [String?] = [
            preparation?.strIngredient1, preparation?.strIngredient2, preparation?.strIngredient3,
            preparation?.strIngredient4, preparation?.strIngredient5, preparation?.strIngredient6,
            preparation?.strIngredient7, preparation?.strIngredient8, preparation?.strIngredient9,
            preparation?.strIngredient10
        ]
        
        let ingredients = zip(cocktailIngredients, preparationIngredients).map { cocktailIng, prepIng in
            cocktailIng ?? prepIng
        }
        
        return ingredients.compactMap { cleanText($0) }.filter { !$0.isEmpty }
    }
    
    private func cleanText(_ text: String?) -> String? {
        guard let text = text else { return nil }
        return text.replacingOccurrences(of: "\"text\":", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct GeneratedCocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratedCocktailDetailView(cocktail: nil, preparation: nil)
            .environmentObject(AppState())
    }
}
