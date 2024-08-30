//
//  RecipeDetailView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct CocktailDetailView: View {
    @EnvironmentObject var appState: AppState
    @State private var cocktail: Cocktail?
    @State private var errorMessage: String?

    let cocktailName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let cocktail = cocktail {
                    CocktailImageView(url: cocktail.strDrinkThumb)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.primary.opacity(0.2), radius: 5, x: 0, y: 2)
                        .frame(maxWidth: .infinity, alignment: .center)

                    CocktailTitleView(title: cocktail.strDrink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.primary)

                    if !cocktail.ingredients.isEmpty {
                        CocktailIngredientsView(ingredients: cocktail.ingredients)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical)
                    }

                    if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                        CocktailInstructionsView(instructions: instructions)
                            .padding(.horizontal)
                            .padding(.vertical)
                    } else {
                        Text("No instructions available.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(UIColor.systemGray5).opacity(0.8))
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                } else {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color(UIColor.systemGray5).opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground).opacity(0.8))
                    .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)
            .navigationTitle(cocktail?.strDrink ?? "Cocktail Detail")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchCocktailDetails)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all) // Ensure the gradient applies to the whole screen, including the navigation bar area
        )
    }

    private func fetchCocktailDetails() {
        NetworkManager.fetchCocktailDetails(forCocktailName: cocktailName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cocktails):
                    self.cocktail = cocktails.first
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CocktailDetailView(cocktailName: "Margarita")
                .environmentObject(AppState())
        }
    }
}
