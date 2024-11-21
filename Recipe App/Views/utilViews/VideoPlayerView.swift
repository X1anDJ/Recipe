//
//  VideoPlayerView.swift
//  Recipe App
//
//  Created by Dajun Xian on 2024/11/21.
//

import SwiftUI

struct VideoPlayerView: View {
    let url: URL

    /// Converts a standard YouTube URL to an embed URL.
    private var embedURL: URL? {
        // Extract the video ID from the URL.
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host,
              host.contains("youtube.com"),
              let queryItems = components.queryItems,
              let v = queryItems.first(where: { $0.name == "v" })?.value else {
            return nil
        }
        // Construct the embed URL.
        return URL(string: "https://www.youtube.com/embed/\(v)?autoplay=1&playsinline=1")

    }

    var body: some View {
        if let embedURL = embedURL {
            WebView(url: embedURL)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Video", displayMode: .inline)
        } else {
            Text("Invalid YouTube URL")
                .foregroundColor(.red)
                .padding()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(url: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!)
    }
}
