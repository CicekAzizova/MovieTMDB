//
//  RemoteImageCache.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//
import SwiftUI
import UIKit

enum CachedImagePhase {
    case empty
    case success(Image)
    case failure
    
}
@MainActor
final class RemoteImageCache {
    static let shared = RemoteImageCache()
    
    private let cache = NSCache<NSURL, UIImage> ()
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

@MainActor
struct CachedRemoteImage<Content: View>: View {
    let url: URL?
    let content: (CachedImagePhase) -> Content
    
    @State private var image: UIImage?
    @State private var didFail = false
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (CachedImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }
    
    private var phase: CachedImagePhase {
        if let image {
            return .success(Image(uiImage: image))
        }
        if let url,
           let cachedImage = RemoteImageCache.shared.image(for: url){
            return .success(Image(uiImage: cachedImage))
        }
        
        if didFail {
            return .failure
        }
        
        return .empty
        
    }
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }
    
    private func loadImage() async {
        image = nil
        didFail = false
        
        guard let url else {
            didFail = true
            return
        }
        if let cachedImage = RemoteImageCache.shared.image(for: url) {
            image = cachedImage
            return
        }
        do {
           let (data, response) = try await URLSession.shared.data(from: url)
            guard !Task.isCancelled else {
                return
            }
            
            guard 
                let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode,
                let downloadedImage = UIImage(data: data) else {
                didFail = true
                return
            }
            
            RemoteImageCache.shared.insert(downloadedImage, for: url)
            image = downloadedImage
            
        } catch  {
            guard !Task.isCancelled else {
                return
            }
            didFail = true
        }
    }
}
