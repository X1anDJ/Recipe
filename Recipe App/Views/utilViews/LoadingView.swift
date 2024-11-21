//
//  LoadingView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Spacer()
        ProgressView("Loading Recipes...")
            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
        Spacer()
    }
}
