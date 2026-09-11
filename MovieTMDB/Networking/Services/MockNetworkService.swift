//
//  MockNetworkService.swift
//  MovieTMDB
//
//  Created by Cicek on 05.09.26.
//
import Foundation

final class MockNetworkService: MovieNetworkService {
   
    
    
    private var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    func fetchGenreList() async throws -> GenreListResponse {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        return GenreListResponse(genres: [Genre(id: 1, name: "genre")])
    }
    func fetchMovies(
        endPoint: MovieEndPoint
    ) async throws -> MoviesResponse {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return MoviesResponse(
            page: 1,
            results: [
                Movie(
                    id: 1,
                    title: "Test Movie",
                    overview: "Test overview",
                    posterPath: nil,
                    backdropPath: nil,
                    releaseDate: "2026-01-01",
                    voteAverage: 8.0,
                    voteCount: 100, genreIds: [1,2]
                )
            ],
            totalPages: 2,
            totalResults: 1
        )
    }

    func fetchMovieDetail(
        id: Int
    ) async throws -> MovieDetail {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return MovieDetail(
            id: 1,
            title: "Movie Detail",
            overview: "Test overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-01-01",
            voteAverage: 8.0,
            voteCount: 100,
            runtime: 1,
            genres: [
                Genre(
                    id: 1,
                    name: "Genre name"
                )
            ],
            tagline: nil,
            status: "Status",
            budget: 1,
            revenue: 4
        )
    }

    func fetchCredits(
        id: Int
    ) async throws -> CreditsResponse {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return CreditsResponse(
            cast: [
                CastMember(
                    id: 1,
                    name: "Credit name",
                    character: "character",
                    profilePath: nil,
                    order: 2
                )
            ],
            crew: [
                CrewMember(
                    id: 1,
                    name: "",
                    job: "job",
                    department: "department"
                )
            ]
        )
    }

    func fetchSimularMovies(
        id: Int,
        page: Int
    ) async throws -> MoviesResponse {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return MoviesResponse(
            page: page,
            results: [
                Movie(
                    id: 1,
                    title: "Test Movie",
                    overview: "Test overview",
                    posterPath: nil,
                    backdropPath: nil,
                    releaseDate: "2026-01-01",
                    voteAverage: 8.0,
                    voteCount: 100, genreIds: [1,2]
                )
            ],
            totalPages: 2,
            totalResults: 1
        )
    }

    func fetchSearchMovies(
        query: String,
        page: Int
    ) async throws -> MoviesResponse {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return MoviesResponse(
            page: page,
            results: [
                Movie(
                    id: 1,
                    title: "Test Movie",
                    overview: "Test overview",
                    posterPath: nil,
                    backdropPath: nil,
                    releaseDate: "2026-01-01",
                    voteAverage: 8.0,
                    voteCount: 100, genreIds: [1,2]
                )
            ],
            totalPages: 2,
            totalResults: 1
        )
    }
    
    func fetchReviews(id: Int, page: Int) async throws -> ReviewsResponse {
        if shouldFail{
            throw NetworkError.serverError(statusCode: 500)
        }
        return ReviewsResponse(results: [Review(id: "1", author: "Author", content: "content", authorDetails: AuthorDetails(rating: 2, avatarPath: "path"))])
    }
}

