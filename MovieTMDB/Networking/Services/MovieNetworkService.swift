//
//  MovieNetworkService.swift
//  MovieTMDB
//
//  Created by Cicek on 05.09.26.
//

import Foundation

protocol MovieNetworkService {
    
    func fetchMovies(endPoint: MovieEndPoint) async throws -> MoviesResponse
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchCredits(id: Int) async throws -> CreditsResponse
    func fetchSimularMovies(id: Int, page: Int) async throws -> MoviesResponse
    func fetchSearchMovies(query: String, page: Int) async throws -> MoviesResponse
    func fetchGenreList() async throws -> GenreListResponse
    func fetchReviews(id: Int, page: Int) async throws -> ReviewsResponse
}

nonisolated struct DefaultMovieService: MovieNetworkService {
  
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMovies(endPoint: MovieEndPoint) async throws -> MoviesResponse {
        return try await networkService.request(endPoint)
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let endPoint = MovieEndPoint.detail(id: id)
        return try await networkService.request(endPoint)
    }
    func fetchCredits(id: Int) async throws -> CreditsResponse {
        let endPoint = MovieEndPoint.credits(id: id)
        return try await networkService.request(endPoint)
    }
    
    func fetchSimularMovies(id: Int, page: Int) async throws -> MoviesResponse {
        let endPoint = MovieEndPoint.similar(id: id, page: page)
        return try await networkService.request(endPoint)
    }
    
    func fetchSearchMovies(query: String, page: Int) async throws -> MoviesResponse {
        let endPoint = MovieEndPoint.search(query: query, page: page)
        return try await networkService.request(endPoint)
    }
    
    func fetchGenreList() async throws -> GenreListResponse {
        let endPoint = MovieEndPoint.genreList
        return try await networkService.request(endPoint)
    }
    
    func fetchReviews(id: Int, page: Int) async throws -> ReviewsResponse {
        let endpoint = MovieEndPoint.reviews(id: id, page: page)
        return try await networkService.request(endpoint)
    }
}
