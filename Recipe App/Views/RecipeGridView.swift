//
//  RecipeGridView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

struct RecipeGridView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var isSortingDialogPresented: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with Title and Sorting Button
                HStack {
                    Text("\(networkManager.selectedCuisine) Recipes")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                        .padding(.bottom, 8)

                    Spacer()

                    // Sorting Button
                    Button(action: {
                        isSortingDialogPresented = true
                    }) {
                        HStack(spacing: 0) {
                            Text(networkManager.sortOption.rawValue)
                                .padding(.trailing, 8)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.primary)
                        .font(.headline)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal)

                // Separator
                Divider()

                // Recipe Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(networkManager.filteredRecipes) { recipe in
                        RecipeCard(recipe: recipe)
                            .id(recipe.id)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
