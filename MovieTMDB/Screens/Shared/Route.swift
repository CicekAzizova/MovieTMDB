//
//  CategoryRoute.swift
//  MovieTMDB
//
//  Created by Cicek on 08.09.26.
//

import Foundation

enum HomeCategory: Hashable {
    case popular
    case topRated
    case upcoming
    case nowPlaying

    var title: String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        case .nowPlaying: return "Now Playing"
        }
    }
}

enum Route: Hashable {
    case category(HomeCategory)
    case detail(Movie)
}
