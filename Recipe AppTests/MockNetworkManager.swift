//
//  MockNetworkManager.swift
//  Recipe AppTests
//
//  Created by Dajun Xian on 2024/11/21.
//

import Foundation
import Combine
@testable import Recipe_App

/// A mock implementation of NetworkManager for testing purposes.
class MockNetworkManager: NetworkManager {
    
    /// Determines whether to simulate a network error.
    var shouldReturnError: Bool = false
    /// The error to return if shouldReturnError is true.
    var error: Error?
    /// Mock recipes to return on successful fetch.
    var mockRecipes: [Recipe] = []
    
    /// Overrides the fetchRecipes method to provide mock data.
    override func fetchRecipes() -> AnyPublisher<[Recipe], Error> {
        if shouldReturnError {
            return Fail(error: error ?? URLError(.unknown))
                .eraseToAnyPublisher()
        } else {
            return Just(mockRecipes)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
