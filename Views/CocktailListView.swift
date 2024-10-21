//
//  CocktailListView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject private var viewModel = CocktailListViewModel()
    let ingredients: [String]
    @EnvironmentObject var appState: AppState

    @State private var currentMessage: String = ""  // Local state for current message
    @State private var isGPTChatActive = false

    // Adaptive grid layout with 2 columns in portrait and dynamic adjustment in landscape
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)  // Minimum size of each card
    ]

    var body: some View {
        ZStack {
            // Background
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
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.cocktails) { cocktail in
                                NavigationLink(destination: CocktailDetailView(cocktailID: cocktail.id).environmentObject(appState)) {
                                    CocktailCardView(cocktail: cocktail)
                                }
                                .buttonStyle(PlainButtonStyle())  // Ensures no extra styling on tap
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Cocktails")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                print("CocktailListView onAppear - ingredients: \(ingredients)")
                if !ingredients.isEmpty {
                    viewModel.fetchCocktails(with: ingredients)
                    currentMessage = ingredients.joined(separator: " ")  // Set initial message with ingredients
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Cocktails")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.accentColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Chat bubble tapped - navigating to GPTChatView with ingredients: \(ingredients)")
                        isGPTChatActive = true
                    }) {
                        Image(systemName: "message.circle.fill")  // Chat bubble icon
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            // NavigationLink to trigger GPT chat view
            NavigationLink(destination: GPTChatView(ingredients: ingredients, currentMessage: $currentMessage).environmentObject(appState), isActive: $isGPTChatActive) {
                EmptyView()
            }
        }
    }
}
