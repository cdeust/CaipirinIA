//
//  Endpoint.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var urlRequest: URLRequest? { get }
}

extension Endpoint {
    var baseURL: String {
        return Config.API.baseURL + Config.API.cocktailDBKey + "/"
    }

    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems

        guard let url = components?.url else { return nil }

        return URLRequest(url: url)
    }
}

enum CocktailDBEndpoint: Endpoint {
    case searchCocktailByName(String)
    case filterCocktailsByIngredients([String])
    case lookupCocktailByID(String) // New case for fetching cocktail details by ID

    var path: String {
        switch self {
        case .searchCocktailByName:
            return "search.php"
        case .filterCocktailsByIngredients:
            return "filter.php"
        case .lookupCocktailByID:
            return "lookup.php"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchCocktailByName(let name):
            return [URLQueryItem(name: "s", value: name)]
        case .filterCocktailsByIngredients(let ingredients):
            let ingredientQuery = ingredients.joined(separator: ",")
            return [URLQueryItem(name: "i", value: ingredientQuery)]
        case .lookupCocktailByID(let id):
            return [URLQueryItem(name: "i", value: id)]
        }
    }
}
