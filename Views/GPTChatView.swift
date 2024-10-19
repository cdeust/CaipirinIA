//
//  GPTChatView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

//
//  GPTChatView.swift
//  CaipirinIA
//

//
//  GPTChatView.swift
//  CaipirinIA
//

import SwiftUI

struct GPTChatView: View {
    @ObservedObject var viewModel: OpenAIChatViewModel
    @EnvironmentObject var appState: AppState
    @Binding var currentMessage: String

    @State private var selectedCocktail: Cocktail? = nil

    init(ingredients: [String], currentMessage: Binding<String>) {
        self._currentMessage = currentMessage
        _viewModel = ObservedObject(wrappedValue: OpenAIChatViewModel(
            cocktailService: CocktailService(),
            detectedIngredients: ingredients
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
            .edgesIgnoringSafeArea(.all)

            VStack {
                // Chat ScrollView
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messageHistory.indices, id: \.self) { index in
                            let message = viewModel.messageHistory[index]
                            Text(message)
                                .padding(12)
                                .background(index % 2 == 0 ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: index % 2 == 0 ? .trailing : .leading)
                                .foregroundColor(Color("PrimaryText"))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                        
                        // Cocktail suggestion section, only displayed once when generatedCocktail is set
                        if let cocktail = viewModel.generatedCocktail {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Suggested Cocktail:")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                // Display the CocktailCardView instead of just text
                                CocktailCardView(cocktail: cocktail)
                                    .onTapGesture {
                                        selectedCocktail = cocktail
                                    }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)

                // Input section (TextField and Send Button)
                HStack(spacing: 10) {
                    // TextField with consistent height
                    TextField("Enter ingredients", text: $currentMessage)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .frame(height: 44)

                    // Send Button with consistent height
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(height: 44)
                    } else {
                        Button(action: {
                            let ingredients = currentMessage.components(separatedBy: ", ")
                            viewModel.sendMessage(ingredients: ingredients, messageToSend: currentMessage)
                            currentMessage = ""
                        }) {
                            Text("Send")
                                .frame(maxWidth: 80, minHeight: 44)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Barman Chat")
            .sheet(item: $selectedCocktail) { cocktail in
                NavigationView {
                    GeneratedCocktailDetailView(cocktail: cocktail, preparation: nil)
                        .environmentObject(appState)
                }
            }
        }
    }
}
