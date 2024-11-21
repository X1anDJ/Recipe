//
//  ContentView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI
import Kingfisher

/// The main view displaying the list of recipes with search and sorting functionalities.
struct ContentView: View {
    /// View model managing recipe data and state.
    @StateObject private var viewModel = RecipeListViewModel()
    /// Proxy for controlling the scroll view, used for scrolling to top.
    @State private var scrollProxy: ScrollViewProxy? = nil
    /// Controls the presentation of the sorting dialog.
    @State private var isSortingDialogPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            // Handle Loading State
                            if viewModel.isLoading {
                                LoadingView()
                            }
                            // Handle Error State
                            else if let error = viewModel.errorMessage {
                                ErrorView(message: error)
                            }
                            // Handle Content
                            else {
                                RecipeContentView(
                                    viewModel: viewModel,
                                    isSortingDialogPresented: $isSortingDialogPresented
                                )
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchRecipes()
                    }
                    .onAppear {
                        self.scrollProxy = proxy
                        viewModel.fetchRecipes()
                        print("Fetch on appearing")
                    }
                }

                if !viewModel.filteredRecipes.isEmpty {
                    Button(action: {
                        withAnimation {
                            if let firstRecipe = viewModel.filteredRecipes.first {
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
            // Sets a dynamic background image based on the first recipe's photo.
            .background(
                BackgroundView(
                    imageURL: viewModel.filteredRecipes.first?.photoURLLarge ?? viewModel.filteredRecipes.first?.photoURLSmall
                )
            )
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            // Enables pull-to-refresh functionality to reload recipes.
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search recipes..."
            )
            // Presents a confirmation dialog for sorting options.
            .confirmationDialog("Sort Recipes", isPresented: $isSortingDialogPresented, titleVisibility: .hidden) {
                Button("A~Z") {
                    viewModel.sortOption = .aToZ
                }
                Button("Z~A") {
                    viewModel.sortOption = .zToA
                }
                Button("Random Order") {
                    viewModel.sortOption = .random
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
