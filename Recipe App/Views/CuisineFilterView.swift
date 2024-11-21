//
//  CuisineFilterView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

struct CuisineFilterView: View {
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(networkManager.allCuisines, id: \.self) { cuisine in
                    Button(action: {
                        withAnimation {
                            networkManager.selectedCuisine = cuisine
                        }
                    }) {
                        Text(cuisine)
                            .font(.subheadline)
                            .foregroundColor(networkManager.selectedCuisine == cuisine ? .primary : .secondary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                    }
                    .background(
                        networkManager.selectedCuisine == cuisine
                            ? .regularMaterial
                            : .thinMaterial,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                }
            }
        }
    }
}
