//
//  MovieDetailViewModel.swift
//  MovieTMDB
//
//  Created by Cicek on 06.09.26.
//
import Foundation

@MainActor
@Observable
final class MovieDetailViewModel {
    var state: MovieViewState = .idle
    private(set) var reviews: [Review] = []
    private(set) var similarMovies: [Movie] = []
    var detail: MovieDetail? = nil
    var credits: CreditsResponse? = nil

    var director: String? {
        credits?.crew.first(where: { $0.job == "Director" })?.name
    }
    
    private let networkService: MovieNetworkService
    
    init(networkService: MovieNetworkService = DefaultMovieService()) {
        self.networkService = networkService
    }
    
    func load(id: Int) async {
        state = .loading
        do {
            async let movieDetail: () = fetchMovieDetail(id: id)
            async let credits: () = fetchCredits(id: id)
            async let simularMovie: () = fetchSimularMovie(id: id)
            
            async let reviewsTask: () = fetchReviews(id: id)
            
            _ = try await (movieDetail, credits, simularMovie,reviewsTask)
            state = detail == nil ? .empty : .loaded
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func fetchMovieDetail(id: Int) async throws {
        detail = try await networkService.fetchMovieDetail(id: id)
    }
    
    func fetchCredits(id: Int) async throws {
        credits = try await networkService.fetchCredits(id: id)
    }
    
    func fetchSimularMovie(id: Int, page: Int = 1) async throws {
        let response = try await networkService.fetchSimularMovies(id: id, page: page)
        similarMovies = response.results
    }
    
    func fetchReviews(id: Int, page: Int = 1) async throws {
        let response = try await networkService.fetchReviews(id: id, page: page)
        reviews = response.results
    }
}
