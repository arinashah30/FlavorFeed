//
//  AssetManager.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/28/23.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var loadedImages: [URL: UIImage] = [:]
    
    func img(url: URL?, properties: @escaping (Image) -> Image) -> some View {
        if let url = url {
            if let image = loadedImages[url] {
                return AnyView(properties(Image(uiImage: image)))
            } else {
                return AnyView(ImageLoaderView(url: url, imageLoader: self, properties: properties))
            }
        } else {
            return AnyView(properties(Image(systemName: "squareshape.fill").resizable()).foregroundColor(.black).scaledToFill().background(Color.black))
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        print("loading image...")
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private func cacheImage(_ image: UIImage?, for url: URL) {
        if let image = image {
            loadedImages[url] = image
        }
    }
    
    private struct ImageLoaderView: View {
        @ObservedObject var imageLoader: ImageLoader
        var url: URL
        var properties: (Image) -> Image
        
        init(url: URL, imageLoader: ImageLoader, properties: @escaping (Image) -> Image) {
            self.url = url
            self.imageLoader = imageLoader
            self.properties = properties
        }
        
        var body: some View {
            if let loadedImage = imageLoader.loadedImages[url] {
                properties(Image(uiImage: loadedImage))
            } else {
                properties(Image(systemName: "squareshape.fill").resizable()).foregroundColor(.black).scaledToFill().background(Color.black) // Placeholder image while loading
                    .onAppear {
                        // Load the image asynchronously
                        self.imageLoader.loadImage(from: self.url) { loadedImage in
                            self.imageLoader.cacheImage(loadedImage, for: self.url)
                        }
                    }
            }
        }
    }
}

