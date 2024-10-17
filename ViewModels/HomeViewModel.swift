//
//  HomeViewModel.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedCocktailID: String? = nil
    @Published var errorMessage: String?

    private let cocktailService: CocktailServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(cocktailService: CocktailServiceProtocol = DependencyContainer.shared.resolve(CocktailServiceProtocol.self)) {
        self.cocktailService = cocktailService
    }

    // Fetch cocktail details based on the preparation's cocktail name
    func fetchCocktailDetails(for preparation: Preparation) {
        let cocktailName = preparation.cocktailName

        // Call the service to fetch cocktail details
        cocktailService.fetchCocktailDetails(by: cocktailName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] cocktail in
                self?.selectedCocktailID = cocktail.idDrink
            }
            .store(in: &cancellables)
    }
}
