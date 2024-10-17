//
//  GPTChatView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import SwiftUI

struct GPTChatView: View {
    @ObservedObject var viewModel: OpenAIChatViewModel
    @EnvironmentObject var appState: AppState

    @State private var selectedCocktail: Cocktail? = nil
    @State private var localIngredients: [String]  // Use state for ingredients to avoid resetting

    init(ingredients: [String]) {
        // Initializing with ingredients and logging them
        self._localIngredients = State(initialValue: ingredients)
        _viewModel = ObservedObject(wrappedValue: OpenAIChatViewModel(cocktailService: CocktailService(), initialIngredients: ingredients))
        print("Initializing GPTChatView with ingredients: \(ingredients)")
    }

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messageHistory.indices, id: \.self) { index in
                    let message = viewModel.messageHistory[index]
                    Text(message)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: message.starts(with: "You") ? .trailing : .leading)
                }
            }
            .padding()

            if let cocktail = viewModel.generatedCocktail {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cocktail: \(cocktail.strDrink)")
                        .font(.headline)
                    
                    Button(action: {
                        selectedCocktail = cocktail
                    }) {
                        Text("See details")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }

            HStack {
                // Binding TextField to currentMessage, using localIngredients for initial value
                TextField("Enter ingredients", text: $viewModel.currentMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        if !localIngredients.isEmpty {
                            // Ensure the textfield shows the ingredients
                            viewModel.currentMessage = localIngredients.joined(separator: ", ")
                            print("TextField onAppear: currentMessage = \(viewModel.currentMessage)")
                        }
                    }

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Send") {
                        let ingredients = viewModel.currentMessage.components(separatedBy: ", ")
                        print("Sending message with ingredients: \(ingredients)")
                        viewModel.sendMessage(ingredients: ingredients)
                        viewModel.currentMessage = ""
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
            }
            .padding()
        }
        .navigationTitle("GPT Chat")
        .onAppear {
            print("GPTChatView appeared with localIngredients: \(localIngredients)")
        }
        .sheet(item: $selectedCocktail) { cocktail in
            GeneratedCocktailDetailView(cocktail: cocktail).environmentObject(appState)
        }
    }
}
