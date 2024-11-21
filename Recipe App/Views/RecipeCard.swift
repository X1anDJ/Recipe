//
//  RecipeCard.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI
import Kingfisher

struct RecipeCard: View {
    let recipe: Recipe
    let infoHeight: CGFloat = 64
    let cardHorizontalPadding: CGFloat = 24
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // Recipe Image with 1:1 Aspect Ratio
                if let url = recipe.photoURLSmall {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .cancelOnDisappear(true)
                        .aspectRatio(1, contentMode: .fill) // Maintain 1:1 aspect ratio
                        .frame(width: geometry.size.width, height: geometry.size.width) // Set height equal to width
                        .clipped()
                        .cornerRadius(16)
                    
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fill) // Maintain 1:1 aspect ratio
                        .frame(width: geometry.size.width, height: geometry.size.width) // Set height equal to width
                        .cornerRadius(16)
                }

                // Recipe Information with Fixed Height
                VStack {
                    // Recipe Name
                    Text(recipe.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    // Cuisine Type
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(height: infoHeight) // Fixed height for recipe information
            }
        }
        .frame(height: (UIScreen.main.bounds.width / 2 - 48) + infoHeight + cardHorizontalPadding) // Card width (half screen) + info height + padding
    }
}
