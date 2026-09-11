//
//  Review.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import Foundation

struct ReviewsResponse: Decodable {
    let results: [Review]
}

struct Review: Decodable, Identifiable {
    let id: String
    let author: String
    let content: String
    let authorDetails: AuthorDetails

}

struct AuthorDetails: Decodable {
    let rating: Double?
    let avatarPath: String?
}
