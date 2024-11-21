//
//  BackgroundView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI
import Kingfisher

struct BackgroundView: View {
    let imageURL: URL?

    var body: some View {
        Group {
            if let imageURL = imageURL {
                KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.65)
                    .ignoresSafeArea()
            } else {
                Color(.systemBackground)
                    .ignoresSafeArea()
            }
        }
    }
}
