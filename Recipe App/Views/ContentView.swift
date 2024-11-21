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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            // Handle Loading State
                            if networkManager.isLoading {
                                LoadingView()
                            }
                            // Handle Error State
                            else if let error = networkManager.errorMessage {
                                ErrorView(message: error)
                            }
                            // Handle Content
                            else {
                                RecipeContentView(
                                    networkManager: networkManager,
                                    isSortingDialogPresented: $isSortingDialogPresented
                                )
                            }
                        }
                    }
                    .refreshable {
                        networkManager.fetchRecipes()
                    }
                    .onAppear {
                        self.scrollProxy = proxy
                        networkManager.fetchRecipes()
                        print("Fetch on appearing")
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
            .background(
                BackgroundView(
                    imageURL: networkManager.filteredRecipes.first?.photoURLLarge ?? networkManager.filteredRecipes.first?.photoURLSmall
                )
            )
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
