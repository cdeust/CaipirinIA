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
    @Binding var currentMessage: String  // Use @Binding for real-time sync with parent view

    @State private var selectedCocktail: Cocktail? = nil

    init(ingredients: [String], currentMessage: Binding<String>) {
        self._currentMessage = currentMessage  // Initialize with the passed Binding
        _viewModel = ObservedObject(wrappedValue: OpenAIChatViewModel(cocktailService: CocktailService(), detectedIngredients: ingredients))
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
                TextField("Enter ingredients", text: $currentMessage)  // Use the Binding here
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Send") {
                        let ingredients = currentMessage.components(separatedBy: ", ")
                        print("Sending message with ingredients: \(ingredients)")
                        viewModel.sendMessage(ingredients: ingredients)
                        currentMessage = ""  // Clear after sending
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
        .sheet(item: $selectedCocktail) { cocktail in
            NavigationView {
                GeneratedCocktailDetailView(cocktail: cocktail, preparation: nil).environmentObject(appState)
            }
        }
    }
}
