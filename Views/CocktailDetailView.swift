//
//  CocktailDetailView 2.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailDetailView: View {
    let cocktailID: String
    @StateObject private var viewModel = CocktailDetailViewModel()
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
                    if viewModel.isLoading {
                        ProgressView("Loading Details...")
                            .padding()
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    } else if let cocktail = viewModel.cocktail {
                        // Cocktail Image
                        CocktailImageView(
                            url: cocktail.strDrinkThumb ?? "",
                            width: UIScreen.main.bounds.size.width,
                            height: 180,
                            accessibilityLabel: "\(cocktail.strDrink)"
                        )
                        .applyShape(.rectangle)

                        // Cocktail Name
                        Text(cocktail.strDrink)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center) // Center the name
                            .padding(.horizontal)

                        // Cocktail Information Section
                        CocktailInfoSection(cocktail: cocktail)
                            .padding(.horizontal)

                        // Ingredients Section
                        CocktailIngredientsView(ingredients: cocktail.ingredients)
                            .padding(.horizontal)

                        // Instructions Section
                        if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                            CocktailInstructionsView(instructions: instructions)
                                .padding(.horizontal)
                        } else {
                            Text("No instructions available.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        
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
                    } else {
                        Text("No details available.")
                            .foregroundColor(.secondary)
                            .padding()
                        Spacer()
                    }
                }
                .padding(.top)
            }
            .navigationTitle(viewModel.cocktail?.strDrink ?? "Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchCocktailDetails(by: cocktailID)
        }
    }

    struct CocktailDetailView_Previews: PreviewProvider {
        static var previews: some View {
            CocktailDetailView(cocktailID: "11007")
                .environmentObject(AppState())
        }
    }
}
