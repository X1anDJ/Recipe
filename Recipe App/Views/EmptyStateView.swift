//
//  EmptyStateView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//
import SwiftUI

struct EmptyStateView: View {
    var message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.gray)

            Text(message)
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(message: "No recipes available.")
    }
}
