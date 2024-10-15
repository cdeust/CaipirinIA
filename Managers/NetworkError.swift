//
//  NetworkError.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(description: String)
    case decodingError
    case serverError(statusCode: Int)
    case noResults
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let description):
            return "Network request failed: \(description)"
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .noResults:
            return "No results found."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
