//
//  CocktailServiceProtocol.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation
import Combine

protocol CocktailServiceProtocol {
    func fetchCocktails(withIngredients ingredients: [String]) -> AnyPublisher<[Cocktail], NetworkError>
    func fetchCocktailDetails(by id: String) -> AnyPublisher<Cocktail, NetworkError>
}

class CocktailService: CocktailServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchCocktails(withIngredients ingredients: [String]) -> AnyPublisher<[Cocktail], NetworkError> {
        let endpoint = CocktailDBEndpoint.filterCocktailsByIngredients(ingredients)
        return networkManager.request(endpoint, responseType: CocktailResponse.self)
            .map { $0.drinks ?? [] }
            .eraseToAnyPublisher()
    }

    func fetchCocktailDetails(by id: String) -> AnyPublisher<Cocktail, NetworkError> {
        let endpoint = CocktailDBEndpoint.lookupCocktailByID(id)
        return networkManager.request(endpoint, responseType: CocktailResponse.self)
            .compactMap { $0.drinks?.first }
            .eraseToAnyPublisher()
    }
}
