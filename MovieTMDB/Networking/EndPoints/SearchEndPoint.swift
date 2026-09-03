//
//  SearchEndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import Foundation

enum SearchEndPoint {
    case search(query: String, page: Int)
}

extension SearchEndPoint: EndPoint {
    var method: HttpMethod {
        .get
    }
    
    var path: String {
        "/search/movie"
        
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: String(query)),
                URLQueryItem(name: "page",value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        }
    }
    
    
}

