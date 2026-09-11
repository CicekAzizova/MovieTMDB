//
//  MovieDetails.swift
//  MovieTMDB
//
//  Created by Cicek on 06.09.26.
//

import Foundation

struct MovieDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    let status: String
    let budget: Int
    let revenue: Int
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
