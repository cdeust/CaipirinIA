//
//  CachedAsyncImage.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View {
    @State private var image: Image? = nil
    let url: URL
    let content: (Image) -> Content

    var body: some View {
        ZStack {
            if let image = image {
                content(image)
            } else {
                ProgressView()
                    .onAppear {
                        fetchImage()
                    }
            }
        }
    }

    private func fetchImage() {
        // Check cache first
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let uiImage = UIImage(data: cachedResponse.data) {
            self.image = Image(uiImage: uiImage)
            return
        }

        // Fetch from network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let uiImage = UIImage(data: data),
                  let response = response else { return }
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }.resume()
    }
}

struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedAsyncImage(url: URL(string: "https://www.thecocktaildb.com/images/media/drink/wpxpvu1439905379.jpg")!) { image in
            image
                .resizable()
                .scaledToFill()
        }
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
