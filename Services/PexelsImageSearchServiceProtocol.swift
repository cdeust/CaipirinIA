//
//  PexelsImageSearchServiceProtocol.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import Foundation
import Combine

protocol PexelsImageSearchServiceProtocol {
    func searchImage(for query: String) -> AnyPublisher<String?, Error>
}

class PexelsImageSearchService: PexelsImageSearchServiceProtocol {
    private let apiKey = "\(Configuration.pexelsApiKey)"
    private let pexelsBaseURL = "https://api.pexels.com/v1/search"
    private let cocktailDbBaseURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php"

    func searchImage(for query: String) -> AnyPublisher<String?, Error> {
        return searchImageOnPexels(for: query)
            .flatMap { pexelsImage -> AnyPublisher<String?, Error> in
                if let pexelsImage = pexelsImage {
                    // If Pexels image is found, return it
                    return Just(pexelsImage)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    // If no image from Pexels, try searching on CocktailDB
                    return self.searchImageOnCocktailDb(for: query)
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Pexels Search

    private func searchImageOnPexels(for query: String) -> AnyPublisher<String?, Error> {
        let modifiedQuery = "\(query) cocktail drink"
        let encodedQuery = modifiedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(pexelsBaseURL)?query=\(encodedQuery)&per_page=1"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        // Log the request URL and headers
        print("Sending request to Pexels API with URL: \(urlString)")
        print("Authorization Header: Bearer \(apiKey.prefix(10))...")

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                print("Request failed with error: \(error.localizedDescription)")
                return error
            }
            .flatMap { data, response -> AnyPublisher<String?, Error> in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Received response with status code: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                    }
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(PexelsImageResponse.self, from: data)
                    print("Decoded Pexels Response: \(decodedResponse)")

                    // Filter the response based on the query keyword matching the description or alt text
                    if let photo = decodedResponse.photos.first {
                        if let altText = photo.alt, altText.lowercased().contains(query.lowercased()) {
                            print("Matching image found: \(photo.src.medium)")
                            return Just(photo.src.medium).setFailureType(to: Error.self).eraseToAnyPublisher()
                        } else {
                            print("No matching description found for query \(query)")
                            return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                        }
                    } else {
                        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                    }
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - CocktailDB Search (Fallback)

    private func searchImageOnCocktailDb(for query: String) -> AnyPublisher<String?, Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(cocktailDbBaseURL)?s=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        // Log the request URL
        print("Sending request to CocktailDB API with URL: \(urlString)")

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error -> Error in
                print("Request failed with error: \(error.localizedDescription)")
                return error
            }
            .flatMap { data, response -> AnyPublisher<String?, Error> in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Received response with status code: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                    }
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(CocktailResponse.self, from: data)
                    print("Decoded CocktailDB Response: \(decodedResponse)")

                    // Extract the image URL from the first matching cocktail, if any
                    if let cocktail = decodedResponse.drinks?.first {
                        return Just(cocktail.strDrinkThumb).setFailureType(to: Error.self).eraseToAnyPublisher()
                    } else {
                        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                    }
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

struct PexelsImageResponse: Codable {
    let photos: [PexelsPhoto]
}

struct PexelsPhoto: Codable {
    let src: PexelsPhotoSource
    let alt: String?
}

struct PexelsPhotoSource: Codable {
    let medium: String
}
