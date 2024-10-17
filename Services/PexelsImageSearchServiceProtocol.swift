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
    private let baseURL = "https://api.pexels.com/v1/search"
    
    func searchImage(for query: String) -> AnyPublisher<String?, Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?query=\(encodedQuery)&per_page=1"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        // Log the full request URL and headers
        print("Sending request to Pexels API with URL: \(urlString)")
        print("Authorization Header: Bearer \(apiKey.prefix(10))...")

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                print("Request failed with error: \(error.localizedDescription)")
                return error
            }
            .flatMap { data, response -> AnyPublisher<String?, Error> in
                if let httpResponse = response as? HTTPURLResponse {
                    // Log the status code and headers of the response
                    print("Received response with status code: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        print("Failed with response code: \(httpResponse.statusCode)")
                        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                    }
                }

                // Log the raw response data
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw Pexels Response: \(responseString)")
                }

                // Attempt to decode the JSON response
                do {
                    let decodedResponse = try JSONDecoder().decode(PexelsImageResponse.self, from: data)
                    // Log the decoded response
                    print("Decoded Pexels Response: \(decodedResponse)")
                    
                    // Extract the first image URL, if available
                    let imageUrl = decodedResponse.photos.first?.src.medium
                    print("Extracted image URL: \(imageUrl ?? "No image found")")
                    return Just(imageUrl).setFailureType(to: Error.self).eraseToAnyPublisher()
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
}

struct PexelsPhotoSource: Codable {
    let medium: String
}
