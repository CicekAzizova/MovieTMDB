//
//  SeeAllViewModel.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import Foundation

@MainActor
@Observable
final class SeeAllViewModel {
    let category: HomeCategory

    private(set) var movies: [Movie] = []
    var state: MovieViewState = .idle
    private(set) var isLoadingNextPage = false

    private var currentPage = 1
    private var totalPages = 1

    private let networkService: MovieNetworkService

    init(category: HomeCategory, networkService: MovieNetworkService = DefaultMovieService()) {
        self.category = category
        self.networkService = networkService
    }

    // İlkin yüklənmə — .task-dan çağırılır
    func loadInitial() async {
        currentPage = 1
        state = .loading
        do {
            let response = try await fetchPage(currentPage)
            movies = response.results
            totalPages = response.totalPages
            state = movies.isEmpty ? .empty : .loaded
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // Siyahının sonuna yaxınlaşanda çağırılır (ForEach-in .onAppear-ində)
    func loadNextPageIfNeeded(currentItem: Movie) async {
        // Yalnız son 3 elementdən birinə çatanda növbəti səhifəni tetiklə
        guard let index = movies.firstIndex(where: { $0.id == currentItem.id }) else { return }
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -3, limitedBy: movies.startIndex) ?? movies.startIndex
        guard index >= thresholdIndex else { return }

        guard !isLoadingNextPage, currentPage < totalPages else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let nextPage = currentPage + 1
            let response = try await fetchPage(nextPage)
            movies.append(contentsOf: response.results)
            currentPage = nextPage
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            print("Yukleme ugursuz")
        }
    }

    private func fetchPage(_ page: Int) async throws -> MoviesResponse {
        let endpoint: MovieEndPoint
        switch category {
        case .popular: endpoint = .popular(page: page)
        case .topRated: endpoint = .topRated(page: page)
        case .upcoming: endpoint = .upcoming(page: page)
        case .nowPlaying: endpoint = .nowPlaying(page: page)
        }
        return try await networkService.fetchMovies(endPoint: endpoint)
    }
}
