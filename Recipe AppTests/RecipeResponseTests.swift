//
//  RecipeResponseTests.swift
//  Recipe AppTests
//
//  Created by Dajun Xian on 2024/11/21.
//

import XCTest
@testable import Recipe_App

/// Unit tests for the RecipeResponse model.
final class RecipeResponseTests: XCTestCase {
    
    /// Tests decoding a valid RecipeResponse with multiple recipes.
    func testRecipeResponseDecoding_ValidJSON() throws {
        // Given: Valid JSON data with multiple recipes.
        let jsonData = """
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
        
        // When: Decoding the JSON data.
        let decoder = JSONDecoder()
        let response = try decoder.decode(RecipeResponse.self, from: jsonData)
        
        // Then: Verify the recipes array.
        XCTAssertEqual(response.recipes.count, 2)
        XCTAssertEqual(response.recipes[0].name, "Apam Balik")
        XCTAssertEqual(response.recipes[1].name, "Apple & Blackberry Crumble")
    }
    
    /// Tests decoding a RecipeResponse with empty recipes array.
    func testRecipeResponseDecoding_EmptyRecipes() throws {
        // Given: JSON data with an empty recipes array.
        let jsonData = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        // When: Decoding the JSON data.
        let decoder = JSONDecoder()
        let response = try decoder.decode(RecipeResponse.self, from: jsonData)
        
        // Then: Verify that recipes array is empty.
        XCTAssertEqual(response.recipes.count, 0)
    }
    
    /// Tests decoding a RecipeResponse from malformed JSON, expecting a decoding failure.
    func testRecipeResponseDecoding_MalformedJSON() {
        // Given: Malformed JSON data.
        let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik"
                    // Missing other fields and comma
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When & Then: Decoding should throw an error.
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(RecipeResponse.self, from: jsonData)) { error in
            print("Decoding failed as expected with error: \(error)")
        }
    }
}
