//
//  CreditsResponse.swift
//  MovieTMDB
//
//  Created by Cicek on 06.09.26.
//

import Foundation

struct CreditsResponse: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int
}

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let department: String
}
