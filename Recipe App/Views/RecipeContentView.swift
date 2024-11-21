//
//  RecipeContentView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

struct RecipeContentView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var isSortingDialogPresented: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Cuisine Filter Buttons
            CuisineFilterView(networkManager: networkManager)
                .padding(.top, 0)
                .padding(.horizontal)

            // Check for No Results Found
            if networkManager.filteredRecipes.isEmpty && !networkManager.searchText.isEmpty {
                ErrorView(message: "No results found.")
            } else {
                RecipeGridView(
                    networkManager: networkManager,
                    isSortingDialogPresented: $isSortingDialogPresented
                )
            }
        }
    }
}
