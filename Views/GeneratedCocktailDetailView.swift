//
//  GeneratedCocktailDetailView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import SwiftUI

struct GeneratedCocktailDetailView: View {
    let cocktail: Cocktail
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

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CocktailImageView(url: cocktail.strDrinkThumb,
                        width: UIScreen.main.bounds.size.width,
                        height: 180,
                        accessibilityLabel: "\(cocktail.strDrink)"
                    )
                    .applyShape(.rectangle)
                    // Cocktail Name
                    Text(cocktail.strDrink)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Cocktail Information Section (Category, Alcohol, Glass)
                    VStack(alignment: .leading, spacing: 8) {
                        if let category = cleanText(cocktail.strCategory) {
                            Text("Category: \(category)")
                        } else {
                            Text("Category: No category available")
                        }

                        if let alcoholic = cleanText(cocktail.strAlcoholic) {
                            Text("Alcoholic: \(alcoholic)")
                        } else {
                            Text("Alcoholic: No alcoholic available")
                        }

                        if let glass = cleanText(cocktail.strGlass) {
                            Text("Glass: \(glass)")
                        } else {
                            Text("Glass: No glass available")
                        }
                    }
                    .padding(.horizontal)

                    // Ingredients Section
                    if let ingredients = getValidIngredients(from: cocktail) {
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
                    } else {
                        Text("No ingredients available.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }

                    // Instructions Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instructions:")
                            .font(.headline)
                        
                        if let instructions = cleanText(cocktail.strInstructions), !instructions.isEmpty {
                            Text(instructions)
                                .padding(.leading)
                                .font(.subheadline)
                        } else {
                            Text("No instructions available.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)

                    // "Prepare" Button
                    NavigationLink(destination: PreparationStepsView(cocktail: cocktail)) {
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

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle(cocktail.strDrink)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Function to clean the text and avoid JSON-like artifacts in the response
    private func cleanText(_ text: String?) -> String? {
        guard let text = text else { return nil }
        return text.replacingOccurrences(of: "\"text\":", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Function to get valid ingredients and clean up any text issues
    private func getValidIngredients(from cocktail: Cocktail) -> [String]? {
        let ingredients = [
            cocktail.strIngredient1, cocktail.strIngredient2, cocktail.strIngredient3,
            cocktail.strIngredient4, cocktail.strIngredient5, cocktail.strIngredient6,
            cocktail.strIngredient7, cocktail.strIngredient8, cocktail.strIngredient9,
            cocktail.strIngredient10, cocktail.strIngredient11, cocktail.strIngredient12,
            cocktail.strIngredient13, cocktail.strIngredient14, cocktail.strIngredient15
        ]

        // Clean and filter out any nil or invalid entries
        return ingredients.compactMap { ingredient in
            return cleanText(ingredient)
        }.filter { !$0.isEmpty }
    }
}
