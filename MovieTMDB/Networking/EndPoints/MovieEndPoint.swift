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
    case nowPlaying
    
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
            }
        }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .popular(page),
             let .topRated(page),
             let .upcoming(page):
            return [URLQueryItem(name: "page", value: String(page))]
        
        case .nowPlaying:
            return nil
        }
    }
    
    var method: HttpMethod {
        .get
    }
    
        
    
}
