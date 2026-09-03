//
//  MovieDetailEndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import Foundation

enum MovieDetailEndPoint {
    case detail(id: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)
}
extension MovieDetailEndPoint: EndPoint {
   
    
    var path: String {
        switch self {
        case .detail(let id):
            "/movie/\(id)"
        case .credits(let id):
            "/movie/\(id)/credits"
        case .similar(let id, _):
            "/movie/\(id)/similar"
        }
    }
    
    var method: HttpMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
       
        case .similar(let id, let page):
            return [URLQueryItem(name: "page", value: String(page))]
            
        case .detail, .credits:
            return nil
        }
    }
    
}
