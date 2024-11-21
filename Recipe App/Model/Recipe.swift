//
//  Recipe.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import Foundation

/// Represents the response from the recipes API.
struct RecipeResponse: Codable {
    /// Array of recipes returned by the API.
    let recipes: [Recipe]
}

/// Represents a single recipe.
struct Recipe: Codable, Identifiable {
    /// Local unique identifier.
    let id = UUID()
    /// Country that the recipe originates
    let cuisine: String
    /// Name of the recipe.
    let name: String
    /// URL for the large version of the recipe photo.
    let photoURLLarge: URL?
    /// URL for the small version of the recipe photo.
    let photoURLSmall: URL?
    /// Source URL for the recipe details.
    let sourceURL: URL?
    /// Unique identifier from the backend.
    let uuid: String
    /// URL for the recipe's YouTube video, if available.
    let youtubeURL: URL?

    /// Maps JSON keys to Swift property names.
    enum CodingKeys: String, CodingKey {
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
