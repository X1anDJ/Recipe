//
//  CuisineFilterView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

/// A horizontal scroll view for filtering recipes by cuisine.
struct CuisineFilterView: View {
    /// View model managing recipe data and state.
    @ObservedObject var viewModel: RecipeListViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // Generate a button for each available cuisine.
                ForEach(viewModel.allCuisines, id: \.self) { cuisine in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedCuisine = cuisine
                        }
                    }) {
                        Text(cuisine)
                            .font(.subheadline)
                            .foregroundColor(viewModel.selectedCuisine == cuisine ? .primary : .secondary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                    }
                    .background(
                        viewModel.selectedCuisine == cuisine
                            ? .regularMaterial
                            : .thinMaterial,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                }
            }
        }
    }
}
