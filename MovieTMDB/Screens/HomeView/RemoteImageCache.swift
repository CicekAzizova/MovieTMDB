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
final class RemoteImageCache {//yuklenmis sekilleri yadda saxlamaq
    static let shared = RemoteImageCache()
    
    private let cache = NSCache<NSURL, UIImage> () //şəkilləri yadda saxlamaq üçün istifadə olunan cache,NSURL -acari,UIImage - tip
    
    func image(for url: URL) -> UIImage? { // URL üçün cache-də şəkil varmı?, yoxdursa nil olacaq
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {//Bu isə şəkli cache-ə əlavə edir.
        cache.setObject(image, forKey: url as NSURL)
    }
}

@MainActor
struct CachedRemoteImage<Content: View>: View {
    let url: URL?
    let content: (CachedImagePhase) -> Content //Şəklin vəziyyətinə görə UI-ni mənə ver.
    
    @State private var image: UIImage? // yuklenmis sekili saxlayir
    @State private var didFail = false // sekilin yuklenmesi ufurlu/ugursuz
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (CachedImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }
    
    private var phase: CachedImagePhase {
        if let image {
            return .success(Image(uiImage: image))// Əgər şəkil artıq yüklənibsə .success qaytar
        }
        if let url,
           let cachedImage = RemoteImageCache.shared.image(for: url){
            return .success(Image(uiImage: cachedImage)) // Əgər cache-də şəkil varsa .success qaytarılır.
        }
        
        if didFail {
            return .failure //Əgər yükləmə uğursuz olubsa:
        }
        
        return .empty //hələ yüklənir.
        
    }
    
    var body: some View {
        content(phase) //Hazırkı vəziyyətə uyğun UI göstərilir
            .task(id: url) { //şəkli yükləməyə başlayır. URL dəyişsə, task-ı yenidən işə sal
                await loadImage()
            }
    }
    
    private func loadImage() async { //Bu async funksiyadır, çünki internetdən məlumat götürür.
        image = nil
        didFail = false // köhnə vəziyyəti təmizləyir
        
        guard let url else { // url yoxdursa return et
            didFail = true
            return
        }
        if let cachedImage = RemoteImageCache.shared.image(for: url) { //Əvvəl cache yoxlanılır,Gör cache-də bu şəkil var?
            image = cachedImage
            return
        }
        do { // Cache-də yoxdursa internetə gedir
           let (data, response) = try await URLSession.shared.data(from: url)
            guard !Task.isCancelled else {// Əgər bu async task artıq ləğv olunubsa, davam etmə.
                return
            }
            
            guard // Response yoxlanılır
                let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode,
                let downloadedImage = UIImage(data: data) else {
                didFail = true
                return
            }
            
            RemoteImageCache.shared.insert(downloadedImage, for: url) // Şəkil cache-ə yazılır
            image = downloadedImage // Sonra View-ə verilir ve @State dəyişir
            
        } catch  {
            guard !Task.isCancelled else {
                return
            }
            didFail = true
        }
    }
}
