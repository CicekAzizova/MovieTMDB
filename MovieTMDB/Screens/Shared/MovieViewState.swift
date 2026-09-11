//
//  MovieViewState.swift
//  MovieTMDB
//
//  Created by Cicek on 06.09.26.
//

enum MovieViewState {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
