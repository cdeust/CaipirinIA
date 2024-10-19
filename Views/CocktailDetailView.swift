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
                            height: 250,
                            shapeType: .roundedRectangle(cornerRadius: 15)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)

                        // Cocktail Name
                        Text(cocktail.strDrink)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .foregroundColor(Color("SecondaryText"))

                        // Cocktail Information Section
                        CocktailInfoSection(category: cocktail.strCategory, alcoholic: cocktail.strAlcoholic, glass: cocktail.strGlass)
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
                                .foregroundColor(Color("PrimaryText"))
                                .padding(.horizontal)
                        }

                        // "Prepare" Button
                        NavigationLink(destination: PreparationStepsView(cocktail: cocktail)) {
                            Text("Prepare")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    } else {
                        Text("No details available.")
                            .foregroundColor(Color("PrimaryText"))
                            .padding()
                        Spacer()
                    }
                }
                .padding(.top)
            }
            .navigationTitle(viewModel.cocktail?.strDrink ?? "Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.cocktail?.strDrink ?? "Details")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.accentColor)
                }
            }
        }
        .onAppear {
            viewModel.fetchCocktailDetails(by: cocktailID)
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailView(cocktailID: "11007")
            .environmentObject(AppState())
    }
}
