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
    private static let baseUrl = "https://api.spoonacular.com/recipes/findByIngredients"

    enum APIError: Error {
        case invalidResponse
        case requestFailed
        case invalidData
    }

    static func fetchRecipes(withIngredients ingredients: [String], completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "apiKey", value: apiKey)
            // Add additional query parameters as needed
        ]

        let url = urlComponents.url!

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
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
