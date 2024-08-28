//
//  NetworkManager.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private static let apiKey = "bef5fc63ff034bad9a7b3f20928c16ef"
    private static let baseUrl = "https://api.spoonacular.com/cocktails"

    enum APIError: Error {
        case invalidResponse
        case requestFailed
        case invalidData
        case decodingError
        case unknown
    }

    static func fetchCocktails(withIngredients ingredients: [String], completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseUrl + "/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "apiKey", value: apiKey)
            // Add additional query parameters as needed
        ]

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidResponse))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }

            do {
                let response = try JSONDecoder().decode(CocktailResponse.self, from: data)
                completion(.success(response.cocktails))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }

    static func fetchAllCocktails(completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseUrl + "/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey)
            // Add additional query parameters as needed
        ]

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidResponse))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }

            do {
                let response = try JSONDecoder().decode(CocktailResponse.self, from: data)
                completion(.success(response.cocktails))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
}
