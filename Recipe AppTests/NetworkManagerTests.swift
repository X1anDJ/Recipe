//
//  NetworkManagerTests.swift
//  Recipe AppTests
//
//  Created by Dajun Xian on 2024/11/21.
//

import XCTest
import Combine
@testable import Recipe_App

/// Unit tests for the NetworkManager class.
final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        // Initialize URLSession with MockURLProtocol.
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        // Initialize NetworkManager with the mocked session.
        networkManager = NetworkManager(session: session)
        cancellables = []
    }
    
    override func tearDown() {
        networkManager = nil
        MockURLProtocol.requestHandler = nil
        cancellables = nil
        super.tearDown()
    }
    
    /// Tests fetching recipes successfully with valid JSON data.
    func testFetchRecipes_Success() {
        // Given: Mock valid JSON response.
        let expectation = self.expectation(description: "FetchRecipesSuccess")
        let sampleJSON = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            // Ensure the request URL is correct.
            XCTAssertEqual(request.url?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            
            // Return a 200 OK response with the sample JSON.
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, sampleJSON)
        }
        
        // When: Calling fetchRecipes.
        networkManager.fetchRecipes()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure with error \(error)")
                }
            }, receiveValue: { recipes in
                // Then: Verify the recipes array.
                XCTAssertEqual(recipes.count, 2)
                XCTAssertEqual(recipes[0].name, "Apam Balik")
                XCTAssertEqual(recipes[1].cuisine, "British")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Tests fetching recipes with malformed JSON data, expecting a decoding failure.
    func testFetchRecipes_MalformedJSON() {
        // Given: Mock malformed JSON response.
        let expectation = self.expectation(description: "FetchRecipesMalformedJSON")
        let malformedJSON = """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble"
                    // Missing comma and other fields
                }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            // Return a 200 OK response with malformed JSON.
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, malformedJSON)
        }
        
        // When: Calling fetchRecipes.
        networkManager.fetchRecipes()
            .sink(receiveCompletion: { completion in
                // Then: Expect a failure due to decoding error.
                if case .failure(let error) = completion {
                    XCTAssertTrue(error is DecodingError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Tests fetching recipes with empty data response.
    func testFetchRecipes_EmptyData() {
        // Given: Mock empty recipes JSON response.
        let expectation = self.expectation(description: "FetchRecipesEmptyData")
        let emptyJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            // Return a 200 OK response with empty recipes.
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, emptyJSON)
        }
        
        // When: Calling fetchRecipes.
        networkManager.fetchRecipes()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure with error \(error)")
                }
            }, receiveValue: { recipes in
                // Then: Verify that recipes array is empty.
                XCTAssertEqual(recipes.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
