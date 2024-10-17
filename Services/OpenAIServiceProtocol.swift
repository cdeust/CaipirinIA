//
//  OpenAIService.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import Foundation
import Combine

protocol OpenAIServiceProtocol {
    func generateCocktail(ingredients: [String]) -> AnyPublisher<String, Error>
}

class OpenAIService: OpenAIServiceProtocol {
    private let apiKey = "\(Configuration.openApiKey)"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func generateCocktail(ingredients: [String]) -> AnyPublisher<String, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let prompt = """
        You are a cocktail expert. I have these ingredients: \(ingredients.joined(separator: ", ")).
        Please suggest a cocktail recipe that can be made with these ingredients. Provide the recipe in the following format:

        - Cocktail Name: The name of the cocktail.
        - Category: The category of the cocktail (e.g., "Cocktail", "Ordinary Drink").
        - Alcoholic: Indicate if the drink is Alcoholic or Non-Alcoholic.
        - Glass: The type of glass used for serving the cocktail.
        - Instructions: Detailed instructions on how to prepare the cocktail.
        - Ingredients: A list of ingredients, each with a measure.
        - Tags: Optional tags that describe the cocktail.
        - Image: A link to an image of the cocktail (only include ingredients and measures that are not null).
        
        Once you've structured the recipe with this information, convert it into the following JSON format, and **omit any fields that are null**:
        {
            "idDrink": "Generated unique ID",
            "strDrink": "Cocktail Name",
            "strDrinkAlternate": null,
            "strTags": "Tags for the cocktail",
            "strVideo": null,
            "strCategory": "Category of the cocktail",
            "strIBA": "IBA category if applicable",
            "strAlcoholic": "Alcoholic or Non-Alcoholic",
            "strGlass": "Type of glass",
            "strInstructions": "Instructions for making the cocktail",
            "strInstructionsES": null,
            "strInstructionsDE": null,
            "strInstructionsFR": null,
            "strInstructionsIT": null,
            "strInstructionsZH-HANS": null,
            "strInstructionsZH-HANT": null,
            "strDrinkThumb": "Valid link to an image of the cocktail, or `null` if no valid link is available",
            "strIngredient1": "Ingredient 1",
            "strIngredient2": "Ingredient 2",
            "strIngredient3": "Ingredient 3",
            "strIngredient4": "Ingredient 4",
            // Only include further ingredients if they are not null
            "strMeasure1": "Measure of Ingredient 1",
            "strMeasure2": "Measure of Ingredient 2",
            "strMeasure3": "Measure of Ingredient 3",
            // Only include further measures if they are not null
            "strImageSource": "Link to the image source",
            "strImageAttribution": "Attribution for the image",
            "strCreativeCommonsConfirmed": "Yes or No",
            "dateModified": "Modification date"
        }
        """

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a cocktail expert."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 1500
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> String in
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let responseBody = String(data: data, encoding: .utf8) ?? "No body"
                        print("Error response body: \(responseBody)")
                        throw URLError(.badServerResponse)
                    }
                }
                // Print the raw response
                let responseString = String(data: data, encoding: .utf8) ?? "No response"
                print("Raw GPT Response: \(responseString)")  // <-- This will print the raw JSON from GPT
                return responseString
            }
            .eraseToAnyPublisher()
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}
