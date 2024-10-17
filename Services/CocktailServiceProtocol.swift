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
    func generateCocktailWithGPT(ingredients: [String]) -> AnyPublisher<Cocktail, Error>
}

class CocktailService: CocktailServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let openAIService: OpenAIServiceProtocol
    private let pexelsService: PexelsImageSearchServiceProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared, openAIService: OpenAIServiceProtocol = OpenAIService(), pexelsService: PexelsImageSearchServiceProtocol = PexelsImageSearchService()) {
        self.openAIService = openAIService
        self.pexelsService = pexelsService
        self.networkManager = networkManager
    }

    func fetchCocktails(withIngredients ingredients: [String]) -> AnyPublisher<[Cocktail], NetworkError> {
        // Map ingredients using IngredientMapper
        let mappedIngredients = IngredientMapper.mapIngredients(ingredients)
        let endpoint = CocktailDBEndpoint.filterCocktailsByIngredients(mappedIngredients)
        
        return networkManager.request(endpoint, responseType: CocktailResponse.self)
            .map { $0.drinks ?? [] }
            .eraseToAnyPublisher()
    }

    func fetchCocktailDetails(by id: String) -> AnyPublisher<Cocktail, NetworkError> {
        let endpoint = CocktailDBEndpoint.lookupCocktailByID(id)
        return networkManager.request(endpoint, responseType: CocktailResponse.self)
            .compactMap { $0.drinks?.first }
            .map { cocktail in
                var modifiedCocktail = cocktail
                modifiedCocktail.source = .cocktailDb
                return modifiedCocktail
            }
            .eraseToAnyPublisher()
    }
    
    func generateCocktailWithGPT(ingredients: [String]) -> AnyPublisher<Cocktail, Error> {
        let mappedIngredients = IngredientMapper.mapIngredients(ingredients)
        
        return openAIService.generateCocktail(ingredients: mappedIngredients)
            .flatMap { response -> AnyPublisher<Cocktail, Error> in
                let pexelsService = PexelsImageSearchService()
                let cocktailMapper = CocktailMapper(pexelsService: pexelsService)
                
                // Return the cocktail publisher from the mapper
                return cocktailMapper.parseGPTResponseToCocktail(response)
            }
            .eraseToAnyPublisher()
    }
}
