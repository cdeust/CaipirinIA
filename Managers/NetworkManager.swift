//
//  NetworkManager.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation
import Combine


protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let urlRequest = endpoint.urlRequest else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .mapError { NetworkError.requestFailed(description: $0.localizedDescription) }
            .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    return Fail(error: .serverError(statusCode: httpResponse.statusCode))
                        .eraseToAnyPublisher()
                }

                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { _ in .decodingError }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
