//
//  NetworkManager.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import Foundation
import Combine

/// Manages network requests for fetching recipes.
class NetworkManager {
    /// The endpoint URL string for fetching recipes.
    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    /// The URLSession instance used for network requests. Defaults to `URLSession.shared`.
    private let session: URLSession
    
    /// Initializes the NetworkManager with a specific URLSession.
    /// - Parameter session: The URLSession to use. Defaults to `URLSession.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetches recipes from the API.
    ///
    /// - Returns: A publisher that emits an array of `Recipe` or an `Error`.
    func fetchRecipes() -> AnyPublisher<[Recipe], Error> {
        guard let url = URL(string: urlString) else {
            // Return a failure publisher if the URL is invalid.
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            // Validate the HTTP response.
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            // Decode the JSON data into RecipeResponse.
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            // Extract the recipes array from the response.
            .map { $0.recipes }
            .eraseToAnyPublisher()
    }
}
