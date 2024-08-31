//
//  NetworkManager.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private static let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"

    enum NetworkError: LocalizedError {
        case invalidURL
        case requestFailed
        case decodingError
        case serverError
        case noResults
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL provided was invalid."
            case .requestFailed:
                return "The request failed. Please check your internet connection and try again."
            case .decodingError:
                return "Failed to decode the response. Please try again later."
            case .serverError:
                return "A server error occurred. Please try again later."
            case .noResults:
                return "No cocktails found for the given ingredients."
            case .unknown(let error):
                return "An unknown error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    // Builds URL for searching cocktail details by name
    private static func buildCocktailDetailsURL(forCocktailName cocktailName: String) -> URL? {
        let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
        var components = URLComponents(string: baseURL)
        components?.queryItems = [URLQueryItem(name: "s", value: cocktailName)]
        return components?.url
    }
    
    // Fetches cocktail details by name
    static func fetchCocktailDetails(forCocktailName cocktailName: String, completion: @escaping (Result<[Cocktail], NetworkError>) -> Void) {
        guard let url = buildCocktailDetailsURL(forCocktailName: cocktailName) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let cocktailResponse = try JSONDecoder().decode(CocktailResponse.self, from: data)
                if let cocktails = cocktailResponse.drinks, !cocktails.isEmpty {
                    completion(.success(cocktails))
                } else {
                    completion(.failure(.noResults))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // Fetches cocktails based on one or more ingredients
    static func fetchCocktails(withIngredients ingredients: [String], completion: @escaping (Result<[Cocktail], NetworkError>) -> Void) {
        guard let url = buildCocktailURL(withIngredients: ingredients) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let cocktailResponse = try JSONDecoder().decode(CocktailResponse.self, from: data)
                if let cocktails = cocktailResponse.drinks, !cocktails.isEmpty {
                    completion(.success(cocktails))
                } else {
                    completion(.failure(.noResults))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // Constructs the URL for searching cocktails by one or more ingredients
    private static func buildCocktailURL(withIngredients ingredients: [String]) -> URL? {
        guard !ingredients.isEmpty else { return nil }
        let encodedIngredients = ingredients.map { $0.replacingOccurrences(of: " ", with: "_") }
        let ingredientQuery = encodedIngredients.joined(separator: ",")
        let urlString = "\(baseUrl)filter.php?i=\(ingredientQuery)"
        return URL(string: urlString)
    }
}
