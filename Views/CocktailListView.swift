//
//  CocktailListView 2.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject private var viewModel: CocktailListViewModel
    let ingredients: [String]
    let container: DependencyContainer

    // Inject dependencies via initializer
    init(ingredients: [String], container: DependencyContainer) {
        self.ingredients = ingredients
        self.container = container
        _viewModel = StateObject(wrappedValue: CocktailListViewModel(
            cocktailService: container.resolve(CocktailServiceProtocol.self),
            appState: container.resolve(AppState.self)
        ))
    }

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                } else if viewModel.cocktails.isEmpty {
                    Text("No cocktails found.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.cocktails) { cocktail in
                                NavigationLink(destination: CocktailDetailView(cocktailID: cocktail.id, container: container)) {
                                    CocktailCardView(cocktail: cocktail)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Cocktails")
            .onAppear {
                viewModel.fetchCocktails(with: ingredients)
            }
        }
    }
}

struct CocktailListView_Previews: PreviewProvider {
    static var previews: some View {
        let container = DependencyContainer()
        let samplePreparation = Preparation(
            id: UUID(),
            cocktailName: "Margarita",
            datePrepared: Date(),
            steps: [
                "Rub the rim of the glass with the lime slice to make the salt stick to it.",
                "Shake the other ingredients with ice.",
                "Carefully pour into the glass."
            ]
        )
        
        let appState = container.resolve(AppState.self)
        appState.preparations = [samplePreparation]
        
        return CocktailListView(ingredients: ["Mint", "Gin"], container: container)
            .environmentObject(appState)
            .previewLayout(.sizeThatFits)
    }
}
