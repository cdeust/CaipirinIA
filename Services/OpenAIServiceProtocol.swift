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
    func followUpRequest(for message: String) -> AnyPublisher<String, Error>
}

class OpenAIService: OpenAIServiceProtocol {
    private let apiKey = "\(Configuration.openApiKey)"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    // Store the conversation history
    private var conversationHistory: [Message] = [
        Message(role: "system", content: "You are a cocktail expert.")
    ]
    
    private var isFirstRequest = true
    
    func generateCocktail(ingredients: [String]) -> AnyPublisher<String, Error> {
        // Create a prompt for the initial cocktail suggestion
        let prompt = """
        I have these ingredients: \(ingredients.joined(separator: " ")).
        Please suggest a cocktail recipe that can be made with these ingredients. Provide the recipe in the following format:

        - Cocktail Name: The name of the cocktail.
        - Category: The category of the cocktail (e.g., "Cocktail", "Ordinary Drink").
        - Alcoholic: Indicate if the drink is Alcoholic or Non-Alcoholic.
        - Glass: The type of glass used for serving the cocktail.
        - Instructions: Detailed instructions on how to prepare the cocktail.
        - Ingredients: A list of ingredients, each with a measure.
        - Tags: Optional tags that describe the cocktail.
        - Image: A link to an image of the cocktail (only include ingredients and measures that are not null).
        
        Format the recipe in JSON format and omit fields that are null.
        
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
        
        // Append the initial prompt to the conversation history
        conversationHistory.append(Message(role: "user", content: prompt))
        isFirstRequest = false

        return sendRequest()
    }

    func followUpRequest(for message: String) -> AnyPublisher<String, Error> {
            // Add the follow-up message without the initial ingredients prompt
            conversationHistory.append(Message(role: "user", content: message))
            
            return sendRequest()
        }

    private func sendRequest() -> AnyPublisher<String, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": conversationHistory.map { ["role": $0.role, "content": $0.content] },
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
                print("Raw GPT Response: \(responseString)")
                return responseString
            }
            .eraseToAnyPublisher()
    }
}

// Structs for handling the message history
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}

enum CocktailError: Error {
    case parsingError
    case networkError
    case genericError

    // This method returns a humorous error message
    var humorousMessage: String {
        let messages = [
            "Oops! I seem to have spilled the drink... Try again?",
            "Looks like the shaker broke! Give me another chance.",
            "The barman is out of ingredients... Can you try that again?",
            "I'm just a simple bartender, but that request was a bit too strong!",
            "Uh oh, the cocktail shaker seems to be stuck. Let’s shake things up again!",
            "Hmm, I think I added too much ice! Let's try making another cocktail.",
            "Even the best bartenders make a mistake... I’ll get it right this time, promise!"
        ]
        return messages.randomElement() ?? "Sorry, something went wrong in the cocktail world!"
    }
}
