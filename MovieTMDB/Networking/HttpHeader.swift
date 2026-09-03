//
//  HttpHeader.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//

enum HttpHeader {
    static let accept = "Accept"
    static let authorization = "Authorization"
}
enum Accept {
    static let json = "application/json"
}
enum Authorization {
    static let token = "Bearer \(APIConfig.accessToken)"
}
