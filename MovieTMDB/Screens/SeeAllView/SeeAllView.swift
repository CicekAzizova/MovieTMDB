//
//  SeeAllView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import SwiftUI

struct SeeAllView: View {
    @State private var viewModel: SeeAllViewModel

    init(category: HomeCategory, networkService: MovieNetworkService = DefaultMovieService()) {
        _viewModel = State(initialValue: SeeAllViewModel(category: category, networkService: networkService))
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        content
            .navigationTitle(viewModel.category.title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadInitial()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")

        case .loaded:
            grid

        case .empty:
            ContentUnavailableView(
                "No Movie",
                systemImage: "text.page",
                description: Text("There are no movies in this category")
            )

        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.loadInitial()
                    }
                }
            }
        }
    }

    private var grid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(value: Route.detail(movie)) {
                        MovieCardView(path: movie.posterPath, size: .posterLarge)
                            .frame(height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .clipped()
                    }
                    .buttonStyle(.plain)
                    .task {
                        await viewModel.loadNextPageIfNeeded(currentItem: movie)
                    }
                }
            }
            .padding(16)

            if viewModel.isLoadingNextPage {
                ProgressView()
                    .padding(.bottom, 16)
            }
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        SeeAllView(category: .popular, networkService: MockNetworkService(shouldFail: false))
    }
}
#Preview("Error") {
    NavigationStack {
        SeeAllView(category: .popular, networkService: MockNetworkService(shouldFail: true))
    }
}
