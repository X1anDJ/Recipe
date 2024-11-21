//
//  RecipeListViewModel.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//
// RecipeListViewModel.swift
// Recipe App

import Foundation
import Combine

enum SortingOption: String, CaseIterable, Identifiable {
    case aToZ = "A~Z"
    case zToA = "Z~A"
    case random = "Random Order"
    
    var id: String { self.rawValue }
}

/// ViewModel managing the list of recipes, including fetching, searching, filtering, and sorting.
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCuisine: String = "All"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortingOption = .aToZ
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager
    
    /// Initializes the ViewModel with an injected NetworkManager.
    /// - Parameter networkManager: The NetworkManager instance to use. Defaults to a new instance.
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        setupBindings()
    }
    
    /// Sets up Combine bindings for search text and selected cuisine.
    private func setupBindings() {
        // Observe changes to searchText and selectedCuisine to update filteredRecipes accordingly.
        Publishers.CombineLatest($searchText, $selectedCuisine)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] (searchText, selectedCuisine) in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    /// Fetches recipes from the network.
    func fetchRecipes() {
        isLoading = true
        errorMessage = nil

        networkManager.fetchRecipes()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Fetch completed")
                case .failure(let error):
                    print("Error fetching recipes: \(error)")
                    self.errorMessage = "Recipes data are malformed."
                    self.recipes = []
                }
            } receiveValue: { [weak self] recipes in
                guard let self = self else { return }
                self.recipes = recipes
                if self.recipes.isEmpty {
                    self.errorMessage = "No recipes available."
                }
            }
            .store(in: &cancellables)
    }
    
    /// Computed property that returns filtered and sorted recipes based on search text and selected cuisine.
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

    /// Computed property that returns all unique cuisines available in the recipes.
    var allCuisines: [String] {
        let cuisines = recipes.map { $0.cuisine }
        let uniqueCuisines = Set(cuisines)
        return ["All"] + uniqueCuisines.sorted()
    }
}
