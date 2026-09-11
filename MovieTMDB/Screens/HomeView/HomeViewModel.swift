//
//  HomeViewModel.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//
import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
   private(set) var popularMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    
    var state: MovieViewState = .idle
    
    private let networkService: MovieNetworkService
    
    init(networkService: MovieNetworkService = DefaultMovieService()) {
        self.networkService = networkService
    }
    
    func fetchMovies(page: Int) async {
        state = .loading
        do {
            async let nowPlaying: () = loadNowPlayingMovies(page: page)
            async let popular: () = loadPopularMovies(page: page)
            async let upcoming: () = loadUpcomingMovies(page: page)
            async let topRated: () = loadTopRatedMovies(page: page)
            
            _ = try await (nowPlaying, popular, upcoming, topRated)
            
            state = popularMovies.isEmpty && topRatedMovies.isEmpty && upcomingMovies.isEmpty && nowPlayingMovies.isEmpty ? .empty : .loaded
        }catch is CancellationError {
            return
        }catch  {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadPopularMovies(page: Int) async throws {
        let response = try await networkService.fetchMovies(endPoint: .popular(page: page))
        popularMovies = response.results
        
    }
    
    func loadTopRatedMovies(page: Int) async throws {
        let response = try await networkService.fetchMovies(endPoint: .topRated(page: page))
        topRatedMovies = response.results
        
        
    }
    
    func loadUpcomingMovies(page: Int) async throws {
        let response = try await networkService.fetchMovies(endPoint: .upcoming(page: page))
        upcomingMovies = response.results
        
    }
    
    func loadNowPlayingMovies(page: Int) async throws {
        let response = try await networkService.fetchMovies(endPoint: .nowPlaying(page: page))
        nowPlayingMovies = response.results
    }
}
