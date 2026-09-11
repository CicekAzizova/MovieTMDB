//
//  SearchView.swift
//  MovieTMDB
//
//  Created by Cicek on 08.09.26.
//

import SwiftUI

struct SearchView: View {
    var viewModel: SearchViewModel
    @Environment(GenreStore.self) private var genreStore
    @State private var query = ""
    
    var body: some View {
        content
            .searchable(text: $query, prompt: "Search Movie")
            .task(id: query) {
                 await performSearch(for: query)
            }
    }
    
    private func performSearch(for query: String) async {
        guard !query.isEmpty else {
            viewModel.results = []
            viewModel.state = .idle
            return
        }
        try? await Task.sleep(for: .milliseconds(400))
        
        guard !Task.isCancelled else { return }
        
        await viewModel.moviesSearch(query: query, page: 1)
        
    }
    
    var searchMovieList: some View {
        ScrollView {
            LazyVStack(alignment: .leading,spacing: 12) {
                ForEach(viewModel.results) { movie in
                    NavigationLink(value: Route.detail(movie)) {
                        MovieDetailHeaderView(path: movie.posterPath,
                                              title: movie.title, voteAverage: movie.voteAverage, genres: genreStore.names(for: movie.genreIds), releaseDate: movie.releaseDate)
                       
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView {
                Label(
                    "Search for Movies",
                    image: .group
                )
            }description: {
                Text("Find your favorite movies by typing a title, genre, or year")
            }
        case .loading:
            ProgressView()
        case .loaded:
            searchMovieList
        case .empty:
            ContentUnavailableView.search(text: query)
        case .error(let message):
            ContentUnavailableView {
                Label("An error occurred.", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            }actions: {
                Button("Try Again"){
                    Task {
                        await viewModel.moviesSearch(query: query, page: 1)
                        
                    }
                }
            }
        }
    }
}

#Preview("Loaded") {
    let vm = SearchViewModel(networkService: MockNetworkService(shouldFail: false))
        vm.state = .loaded
        vm.results = [Movie(
        id: 1,
        title: "Test Movie",
        overview: "Overview",
        posterPath: nil,
        backdropPath: nil,
        releaseDate: "2024-01-01",
        voteAverage: 8.0,
        voteCount: 100,
        genreIds: [28]
    )]
    
   return NavigationStack {
       SearchView(viewModel: vm)
    }
    .environment(GenreStore())
}
#Preview("Error") {
    let vm = SearchViewModel(networkService: MockNetworkService(shouldFail: true))
    vm.state = .error("Server xetasi: 500")
    
   return NavigationStack {
       SearchView(viewModel: vm)
    }
    .environment(GenreStore())
}
