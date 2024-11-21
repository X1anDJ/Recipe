//
//  NetworkManager.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//
// Networking/NetworkManager.swift

import Foundation
import Combine

enum SortingOption: String, CaseIterable, Identifiable {
    case aToZ = "A~Z"
    case zToA = "Z~A"
    case random = "Random Order"
    
    var id: String { self.rawValue }
}

class NetworkManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCuisine: String = "All"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortingOption = .aToZ  // Added sorting option
    
    private var cancellables = Set<AnyCancellable>()
//    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
//    //    Malformed Data:
//    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"

    //    Empty Data:
    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    
    func fetchRecipes() {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
                self.recipes = []
            }
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Successfully fetched recipes.")
                case .failure(let error):
                    print("Error fetching recipes: \(error)")
                    self.errorMessage = "Recipes data are malformed."
                    self.recipes = [] // Disregard the entire list
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.recipes = response.recipes
                if self.recipes.isEmpty {
                    self.errorMessage = "No recipes available."
                }
            }
            .store(in: &cancellables)
    }

    var filteredRecipes: [Recipe] {
        var filtered = recipes

        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.cuisine.lowercased().contains(searchText.lowercased())
            }
        }

        // Apply cuisine filter
        if selectedCuisine != "All" {
            filtered = filtered.filter { $0.cuisine == selectedCuisine }
        }
        
        // Apply sorting
        switch sortOption {
        case .aToZ:
            filtered.sort { $0.name.lowercased() < $1.name.lowercased() }
        case .zToA:
            filtered.sort { $0.name.lowercased() > $1.name.lowercased() }
        case .random:
            filtered.shuffle()
        }
        
        return filtered
    }

    // Get all unique cuisine types
    var allCuisines: [String] {
        let cuisines = recipes.map { $0.cuisine }
        let uniqueCuisines = Set(cuisines)
        return ["All"] + uniqueCuisines.sorted()
    }
}
