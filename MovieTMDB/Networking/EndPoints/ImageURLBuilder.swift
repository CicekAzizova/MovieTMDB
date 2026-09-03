//
//  ImageEndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import Foundation

enum ImageSize: String {
    case posterSmall = "w342"
    case posterLarge = "w500"
    case backdropSmall = "w780"
    case backdropLarge = "w1280"
    case profile = "w185"
}
enum ImageURLBuilder {
    private static let baseUrl = "https://image.tmdb.org/t/p"
    
    static func url (path: String? , size: ImageSize) -> URL? {
        guard let path else { return nil}
        return URL(string: baseUrl + "/" + size.rawValue + path )
    }
}
