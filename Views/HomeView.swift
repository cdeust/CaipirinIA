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
    @State private var selectedCocktailID: String? = nil
    @State private var selectedPreparation: Preparation? = nil

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
                                        selectedPreparation = preparation
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
                    destination: GeneratedCocktailDetailView(cocktail: nil, preparation: selectedPreparation),
                    isActive: Binding(
                        get: { selectedCocktailID != nil },
                        set: { isActive in
                            if !isActive {
                                selectedCocktailID = nil
                            }
                        }
                    )
                ) {
                    EmptyView()  // You need a valid view here, like `EmptyView()` for a label
                }
            )
        }
    }
}
