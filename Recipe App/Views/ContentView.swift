//
//  ContentView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State private var isSortingDialogPresented: Bool = false

    var backgroundView: some View {
        Group {
            if let firstRecipe = networkManager.filteredRecipes.first,
               let imageURL = firstRecipe.photoURLLarge ?? firstRecipe.photoURLSmall {
                KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.65)
                    .ignoresSafeArea()
            } else {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            // Handle Loading State
                            if networkManager.isLoading {
                                Spacer()
                                ProgressView("Loading Recipes...")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                Spacer()
                            }
                            // Handle Error State
                            else if let error = networkManager.errorMessage {
                                Spacer()
                                EmptyStateView(message: error)
                                Spacer()
                            }
                            // Handle Content
                            else {
                                // Cuisine Filter Buttons (Horizontal Scroll)
                                CuisineFilterView(networkManager: networkManager)
                                    .padding(.top, 0)
                                    .padding(.horizontal)

                                // Check for No Results Found
                                if networkManager.filteredRecipes.isEmpty && !networkManager.searchText.isEmpty {
                                    Spacer()
                                    EmptyStateView(message: "No results found.")
                                    Spacer()
                                }
                                // Display Recipe Grids
                                else {
                                    // Recipe Grids Container
                                    ZStack {
                                        VStack(spacing: 0) {
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

                                            LazyVGrid(
                                                columns: [
                                                    GridItem(.flexible(), spacing: 16),
                                                    GridItem(.flexible(), spacing: 16)
                                                ],
                                                spacing: 16 // Vertical spacing between items
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

                        }

                    }
                    .refreshable {
                        networkManager.fetchRecipes()
                        print("Fetched by pulling")
                    }
                    .onAppear {
                        self.scrollProxy = proxy
                        networkManager.fetchRecipes()
                        print("Fetch by appearing")
                    }
                }

                if !networkManager.filteredRecipes.isEmpty {
                    Button(action: {
                        withAnimation {
                            if let firstRecipe = networkManager.filteredRecipes.first {
                                scrollProxy?.scrollTo(firstRecipe.id, anchor: .top)
                            }
                        }
                    }) {
                        Image(systemName: "arrow.up.to.line.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding()
                }

            }
            .background(backgroundView)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $networkManager.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search recipes..."
            )
            // Confirmation Dialog for Sorting Options
            .confirmationDialog("Sort Recipes", isPresented: $isSortingDialogPresented, titleVisibility: .hidden) {
                Button("A~Z") {
                    networkManager.sortOption = .aToZ
                }
                Button("Z~A") {
                    networkManager.sortOption = .zToA
                }
                Button("Random Order") {
                    networkManager.sortOption = .random
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
