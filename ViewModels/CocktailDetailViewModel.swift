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
    private let appState: AppState
    private var cancellables = Set<AnyCancellable>()
    
    // Inject CocktailServiceProtocol and AppState via initializer
    init(cocktailService: CocktailServiceProtocol, appState: AppState) {
        self.cocktailService = cocktailService
        self.appState = appState
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
        if !appState.previousCocktails.contains(where: { $0.id == detail.idDrink }) {
            appState.previousCocktails.append(detail)
        }
    }
}
