//
//  HomeView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedCocktailID: String? = nil  // To track the selected cocktail ID

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.headline)
                            .foregroundColor(Color("PrimaryText"))
                        
                        Text("CaipirinIA")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("SecondaryText"))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Content
                    if appState.preparations.isEmpty {
                        EmptyStateView()
                            .padding(.top, 60)
                            .transition(.opacity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(appState.preparations) { preparation in
                                    // Trigger fetching of cocktail details
                                    Button(action: {
                                        selectedCocktailID = preparation.cocktailId
                                    }) {
                                        PreparationCardView(preparation: preparation)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .transition(.opacity)
                    }

                    Spacer()

                    // Custom Tab Bar
                    FakeTabBar()
                }
            }
            .navigationBarHidden(true)
            // NavigationLink to CocktailDetailView, once the cocktailID is fetched
            .background(
                NavigationLink(
                    destination: CocktailDetailView(cocktailID: selectedCocktailID ?? ""),
                    isActive: Binding(
                        get: { selectedCocktailID != nil },
                        set: { isActive in
                            if !isActive {
                                selectedCocktailID = nil
                            }
                        }
                    )
                ) {
                    EmptyView()
                }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample Preparations
        let samplePreparationWithImage = Preparation(
            id: UUID(),
            cocktailId: "1107",
            cocktailName: "Margarita",
            datePrepared: Date(),
            steps: [
                "Rub the rim of the glass with the lime slice to make the salt stick to it.",
                "Shake the other ingredients with ice.",
                "Carefully pour into the glass."
            ],
            imageName: URL(string:"MargaritaImage") // Ensure this image exists in your Assets.xcassets
        )
        
        let samplePreparationWithoutImage = Preparation(
            id: UUID(),
            cocktailId: "1120",
            cocktailName: "Old Fashioned",
            datePrepared: Date(),
            steps: [
                "Place sugar cube in old fashioned glass and saturate with bitters.",
                "Muddle until dissolved.",
                "Fill the glass with ice cubes and add whiskey.",
                "Garnish with orange slice and cocktail cherry."
            ],
            imageName: nil // No image provided; placeholder will be used
        )
        
        // Initialize AppState with sample preparations
        let appState = AppState()
        appState.preparations = [samplePreparationWithImage, samplePreparationWithoutImage]
        
        return HomeView()
            .environmentObject(appState)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
