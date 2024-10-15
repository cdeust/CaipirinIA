//
//  CocktailDetailViewModel.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation
import Combine

class CocktailDetailViewModel: ObservableObject {
    @Published var cocktail: Cocktail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cocktailService: CocktailServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(cocktailService: CocktailServiceProtocol = DependencyContainer.shared.resolve(CocktailServiceProtocol.self)) {
        self.cocktailService = cocktailService
    }

    func fetchCocktailDetails(by id: String) {
        guard !id.isEmpty else {
            self.errorMessage = "Invalid Cocktail ID."
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        cocktailService.fetchCocktailDetails(by: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
                self?.isLoading = false
            } receiveValue: { [weak self] cocktailDetail in
                self?.cocktail = cocktailDetail
                self?.addToPreviousCocktails(cocktailDetail)
            }
            .store(in: &cancellables)
    }
    
    private func addToPreviousCocktails(_ detail: Cocktail) {
        let appState = DependencyContainer.shared.resolve(AppState.self)
        
        // Check if the cocktail already exists
        if !appState.previousCocktails.contains(where: { $0.id == detail.idDrink }) {
            // Map CocktailDetail to Cocktail if necessary
            let cocktail = detail
            appState.previousCocktails.append(cocktail)
        }
    }
}