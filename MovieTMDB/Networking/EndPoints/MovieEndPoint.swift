//
//  MovieEndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//

//
//  MovieEndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//

import Foundation

enum MovieEndPoint {
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case nowPlaying(page: Int)
    case detail(id: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)
    case search(query: String, page: Int)
    case genreList
    case reviews(id: Int, page: Int)
    
}

extension MovieEndPoint : EndPoint {
    
    var path: String {
        switch self {
        case .popular:
            "/movie/popular"
        case .topRated:
            "/movie/top_rated"
        case .upcoming:
            "/movie/upcoming"
        case .nowPlaying:
            "/movie/now_playing"
        case .detail(id: let id):
            "/movie/\(id)"
        case .credits(id: let id):
            "/movie/\(id)/credits"
        case .similar(id: let id, page: _):
            "/movie/\(id)/similar"
        case .search:
            "/search/movie"
        case .genreList:
            "/genre/movie/list"
        case .reviews(id: let id, page: _):
            "/movie/\(id)/reviews"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .popular(page),
            let .topRated(page),
            let .upcoming(page),
            let .nowPlaying(page):
            return [URLQueryItem(name: "page", value: String(page))]
            
        case .detail:
            return nil
        case .credits:
            return nil
        case let .similar(_, page):
            return [URLQueryItem(name: "page", value: String(page))]
        case let .search(query, page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        case .genreList:
            return nil
        case .reviews(id: _, page: let page):
            return [URLQueryItem(name: "page", value: String(page))]
        }
    }
    
    var method: HttpMethod {
        .get
    }
}
