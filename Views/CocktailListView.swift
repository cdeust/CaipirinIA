//
//  CocktailListView 2.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject private var viewModel = CocktailListViewModel()
    let ingredients: [String]
    @EnvironmentObject var appState: AppState
    
    // State variable to control navigation
    @State private var isGPTChatActive = false

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
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.cocktails) { cocktail in
                                NavigationLink(destination: CocktailDetailView(cocktailID: cocktail.id).environmentObject(appState)) {
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
                print("CocktailListView onAppear - ingredients: \(ingredients)")
                if !ingredients.isEmpty {
                    viewModel.fetchCocktails(with: ingredients)
                }
            }
            .toolbar {
                // Add the chat bubble to the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Log when the chat bubble is tapped
                        print("Chat bubble tapped - navigating to GPTChatView with ingredients: \(ingredients)")
                        isGPTChatActive = true
                    }) {
                        Image(systemName: "message.circle.fill")  // Using SF Symbols for a chat bubble icon
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }

            // NavigationLink to trigger GPT chat view
            NavigationLink(destination: GPTChatView(ingredients: ingredients).environmentObject(appState), isActive: $isGPTChatActive) {
                EmptyView()
            }
        }
    }
}
