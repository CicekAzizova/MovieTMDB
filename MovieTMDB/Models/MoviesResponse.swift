//
//  MoviesResponse.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
}
