//
//  RecipeTests.swift
//  Recipe AppTests
//
//  Created by Dajun Xian on 2024/11/21.
//

import XCTest
@testable import Recipe_App

/// Unit tests for the Recipe model.
final class RecipeTests: XCTestCase {
    
    /// Tests decoding a valid Recipe from JSON.
    func testRecipeDecoding_ValidJSON() throws {
        // Given: Valid JSON data for a single recipe.
        let jsonData = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """.data(using: .utf8)!
        
        // When: Decoding the JSON data.
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: jsonData)
        
        // Then: Verify all properties are correctly decoded.
        XCTAssertEqual(recipe.cuisine, "Malaysian")
        XCTAssertEqual(recipe.name, "Apam Balik")
        XCTAssertEqual(recipe.photoURLLarge?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        XCTAssertEqual(recipe.photoURLSmall?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        XCTAssertEqual(recipe.sourceURL?.absoluteString, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        XCTAssertEqual(recipe.uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
        XCTAssertEqual(recipe.youtubeURL?.absoluteString, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    }
    
    /// Tests decoding a Recipe with missing optional fields.
    func testRecipeDecoding_MissingOptionalFields() throws {
        // Given: JSON data with some optional fields missing.
        let jsonData = """
        {
            "cuisine": "British",
            "name": "Apple & Blackberry Crumble",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "youtube_url": null
        }
        """.data(using: .utf8)!
        
        // Decoding the JSON data.
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: jsonData)
        
        // Verify properties, especially optional ones.
        XCTAssertEqual(recipe.cuisine, "British")
        XCTAssertEqual(recipe.name, "Apple & Blackberry Crumble")
        XCTAssertEqual(recipe.photoURLLarge?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")
        XCTAssertEqual(recipe.photoURLSmall?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")
        XCTAssertEqual(recipe.sourceURL?.absoluteString, "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble")
        XCTAssertEqual(recipe.uuid, "599344f4-3c5c-4cca-b914-2210e3b3312f")
        XCTAssertNil(recipe.youtubeURL)
    }
    
    /// Tests decoding a Recipe from malformed JSON, expecting a decoding failure.
    func testRecipeDecoding_MalformedJSON() {
        // Given: Malformed JSON data.
        let jsonData = """
        {
            "cuisine": "British",
            "name": "Apple & Blackberry Crumble",
            // Missing comma and other fields
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg"
        }
        """.data(using: .utf8)!
        
        // When & Then: Decoding should throw an error.
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Recipe.self, from: jsonData)) { error in
            print("Decoding failed as expected with error: \(error)")
        }
    }
}
