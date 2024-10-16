//
//  CocktailListViewModel.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation
import Combine

class CocktailListViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var errorMessage: String?

    private let cocktailService: CocktailServiceProtocol
    private let appState: AppState
    private var cancellables = Set<AnyCancellable>()

    init(cocktailService: CocktailServiceProtocol, appState: AppState) {
        self.cocktailService = cocktailService
        self.appState = appState
    }

    func fetchCocktails(with ingredients: [String]) {
        cocktailService.fetchCocktails(withIngredients: ingredients)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] cocktails in
                self?.cocktails = cocktails
            }
            .store(in: &cancellables)
    }
}
