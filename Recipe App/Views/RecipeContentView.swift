//
//  RecipeContentView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

/// Displays the main content including filters and recipe grid.
struct RecipeContentView: View {
    /// View model managing recipe data and state.
    @ObservedObject var viewModel: RecipeListViewModel
    /// Binding to control the presentation of the sorting dialog.
    @Binding var isSortingDialogPresented: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Cuisine Filter Buttons
            CuisineFilterView(viewModel: viewModel)
                .padding(.top, 0)
                .padding(.horizontal)

            // Check for No Results Found
            if viewModel.filteredRecipes.isEmpty && !viewModel.searchText.isEmpty {
                ErrorView(message: "No results found.")
            } else {
                // Display the grid of recipes.
                RecipeGridView(
                    viewModel: viewModel,
                    isSortingDialogPresented: $isSortingDialogPresented
                )
            }
        }
    }
}
