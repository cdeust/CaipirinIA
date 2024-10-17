//
//  OpenAIChatViewModel.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import Combine
import Foundation

class OpenAIChatViewModel: ObservableObject {
    @Published var messageHistory: [String] = []
    @Published var currentMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var generatedCocktail: Cocktail?
    
    private var cancellables = Set<AnyCancellable>()
    private let cocktailService: CocktailServiceProtocol
    
    init(cocktailService: CocktailServiceProtocol, initialIngredients: [String]) {
        self.cocktailService = cocktailService
        self.currentMessage = initialIngredients.joined(separator: ", ")  // Set ingredients here
        print("OpenAIChatViewModel initialized with ingredients: \(initialIngredients)")
    }
    
    func sendMessage(ingredients: [String]) {
        guard !ingredients.isEmpty else { return }

        isLoading = true
        messageHistory.append("You: What can I make with \(ingredients.joined(separator: ", "))?")

        // Fetch a generated cocktail from GPT based on the ingredients
        cocktailService.generateCocktailWithGPT(ingredients: ingredients)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.messageHistory.append("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { cocktail in
                self.messageHistory.append("GPT: Here's a cocktail for you!")
                print("\(cocktail)")
                self.generatedCocktail = cocktail
            })
            .store(in: &cancellables)
    }
}
