//
//  SearchViewModel.swift
//  MovieTMDB
//
//  Created by Cicek on 08.09.26.
//

import Foundation

@MainActor
@Observable
final class SearchViewModel {
    var results: [Movie] = []
    
    var state: MovieViewState = .idle
    
    private let networkService: MovieNetworkService
    private var query = ""
    
    init(networkService: MovieNetworkService = DefaultMovieService()) {
        self.networkService = networkService
    }
    
    func moviesSearch(query: String,page: Int)
    async {
        state = .loading
        do {
            let response = try await networkService.fetchSearchMovies(query: query, page: page)
            results = response.results
            state = results.isEmpty ? .empty : .loaded
        }catch is CancellationError {
             return
        }catch {
            state = .error(error.localizedDescription)
        }
    }
}
