//
//  CocktailMapper.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import Foundation
import Combine

class CocktailMapper {
    private let pexelsService: PexelsImageSearchServiceProtocol

    init(pexelsService: PexelsImageSearchServiceProtocol) {
        self.pexelsService = pexelsService
    }

    func parseGPTResponseToCocktail(_ response: String) -> AnyPublisher<Cocktail, Error> {
        // First, decode the outer GPT response structure
        guard let gptResponseData = response.data(using: .utf8) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()  // Handle bad data
        }

        do {
            // Decode the GPT response
            let gptResponse = try JSONDecoder().decode(OpenAIResponse.self, from: gptResponseData)

            // Extract the JSON string from `choices[0].message.content`
            let cocktailJSONString = gptResponse.choices.first?.message.content ?? ""

            // Decode the cocktail JSON (which is stringified)
            guard let cocktailData = cocktailJSONString.data(using: .utf8) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()  // Handle bad data
            }

            // Decode into a Cocktail object
            let decodedCocktail = try JSONDecoder().decode(Cocktail.self, from: cocktailData)

            // Check if a thumbnail is available
            if let thumbnail = decodedCocktail.strDrinkThumb, !thumbnail.isEmpty {
                // Test if the provided URL is valid (i.e., doesn't return 404)
                return validateImageUrl(thumbnail)
                    .flatMap { isValid in
                        if isValid {
                            // If the URL is valid, return the decoded cocktail as-is
                            return Just(decodedCocktail).setFailureType(to: Error.self).eraseToAnyPublisher()
                        } else {
                            // If the URL is invalid, fallback to fetching from Pexels
                            return self.fetchImageFromPexels(for: decodedCocktail)
                        }
                    }
                    .eraseToAnyPublisher()
            } else {
                // No thumbnail provided, fetch from Pexels directly
                return fetchImageFromPexels(for: decodedCocktail)
            }
        } catch {
            print("Failed to decode GPT response: \(error)")
            print("Raw GPT Response: \(response)")
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func validateImageUrl(_ url: String) -> AnyPublisher<Bool, Error> {
        guard let imageURL = URL(string: url) else {
            return Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        var request = URLRequest(url: imageURL)
        request.httpMethod = "HEAD"  // Use HEAD to avoid downloading the entire image

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { response in
                if let httpResponse = response.response as? HTTPURLResponse {
                    return (200...299).contains(httpResponse.statusCode)  // Return true if the URL is valid
                }
                return false
            }
            .catch { _ in Just(false).setFailureType(to: Error.self) }  // Return false on any error
            .eraseToAnyPublisher()
    }

    private func fetchImageFromPexels(for cocktail: Cocktail) -> AnyPublisher<Cocktail, Error> {
        return pexelsService.searchImage(for: cocktail.strDrink)
            .map { imageUrl in
                var updatedCocktail = cocktail
                updatedCocktail.strDrinkThumb = imageUrl
                return updatedCocktail
            }
            .catch { _ in Just(cocktail).setFailureType(to: Error.self) }  // If Pexels fails, return the original cocktail
            .eraseToAnyPublisher()
    }

    // Create a default cocktail in case of any issues
    private static func createDefaultCocktail() -> Cocktail {
        return Cocktail(
            idDrink: nil,
            strDrink: "Unknown Cocktail",
            strDrinkAlternate: nil,
            strTags: nil,
            strVideo: nil,
            strCategory: "No category available",
            strIBA: nil,
            strAlcoholic: "No alcoholic available",
            strGlass: "No glass available",
            strInstructions: "No instructions available",
            strInstructionsES: nil,
            strInstructionsDE: nil,
            strInstructionsFR: nil,
            strInstructionsIT: nil,
            strInstructionsZH_HANS: nil,
            strInstructionsZH_HANT: nil,
            strDrinkThumb: nil,
            strIngredient1: "Unknown Ingredient",
            strIngredient2: nil,
            strIngredient3: nil,
            strIngredient4: nil,
            strIngredient5: nil,
            strIngredient6: nil,
            strIngredient7: nil,
            strIngredient8: nil,
            strIngredient9: nil,
            strIngredient10: nil,
            strIngredient11: nil,
            strIngredient12: nil,
            strIngredient13: nil,
            strIngredient14: nil,
            strIngredient15: nil,
            strMeasure1: "Unknown",
            strMeasure2: nil,
            strMeasure3: nil,
            strMeasure4: nil,
            strMeasure5: nil,
            strMeasure6: nil,
            strMeasure7: nil,
            strMeasure8: nil,
            strMeasure9: nil,
            strMeasure10: nil,
            strMeasure11: nil,
            strMeasure12: nil,
            strMeasure13: nil,
            strMeasure14: nil,
            strMeasure15: nil,
            strImageSource: nil,
            strImageAttribution: nil,
            strCreativeCommonsConfirmed: nil,
            dateModified: nil
        )
    }
}
