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
    let detectedIngredients: [String]  // Store the initial ingredients
    
    private var cancellables = Set<AnyCancellable>()
    private let cocktailService: CocktailServiceProtocol
    private var messageToSend: String = ""

    init(cocktailService: CocktailServiceProtocol, detectedIngredients: [String]) {
        self.cocktailService = cocktailService
        self.detectedIngredients = detectedIngredients
        self.currentMessage = detectedIngredients.joined(separator: ", ")
    }
    
    func sendMessage(ingredients: [String], messageToSend: String) {
        guard !ingredients.isEmpty else { return }

        isLoading = true
        self.messageToSend = messageToSend

        if messageToSend.isEmpty {
            messageHistory.append("What can I make with \(ingredients.joined(separator: ", "))?")
        } else {
            messageHistory.append("\(messageToSend)")
        }

        // Fetch a generated cocktail from GPT based on the ingredients
        cocktailService.generateCocktailWithGPT(ingredients: ingredients)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.messageHistory.append(self.getHumorousErrorMessage(for: error))
                }
            }, receiveValue: { cocktail in
                self.messageHistory.append("Here's a cocktail for you!")
                self.generatedCocktail = cocktail
            })
            .store(in: &cancellables)
        
        // Clear the input message after sending
        currentMessage = ""
    }

    private func getHumorousErrorMessage(for error: Error) -> String {
        let errorMessages = [
            "Oops! I seem to have spilled the drink... Try again?",
            "Looks like the shaker broke! Give me another chance.",
            "The barman is out of ingredients... Can you try that again?",
            "I'm just a simple bartender, but that request was a bit too strong!",
            "Uh oh, the cocktail shaker seems to be stuck. Let’s shake things up again!"
        ]
        return errorMessages.randomElement() ?? "Sorry, something went wrong in the cocktail world!"
    }
}
