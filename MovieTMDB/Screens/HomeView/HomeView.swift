//
//  HomeView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

//
//  HomeView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import SwiftUI

struct HomeView: View {
    var viewModel: HomeViewModel

    @Binding var path: NavigationPath
    @Binding var selectedTab: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                searchBarButton
                content
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("What do you want to watch?")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMovies(page: 1)
        }
        .refreshable {
            await viewModel.fetchMovies(page: 1)
        }
    }

    private var searchBarButton: some View {
        Button {
            selectedTab = 1   
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                Text("Search")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")

        case .loaded:
            carouselSection(title: "Popular", movies: viewModel.popularMovies, category: .popular)
            carouselSection(title: "Top Rated", movies: viewModel.topRatedMovies, category: .topRated)
            carouselSection(title: "Now Playing", movies: viewModel.nowPlayingMovies, category: .nowPlaying)
            carouselSection(title: "Upcoming", movies: viewModel.upcomingMovies, category: .upcoming)
        case .empty:
            ContentUnavailableView(
                "No Movie",
                systemImage: "text.page",
                description: Text("There are not Movies")
            )
        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.fetchMovies(page: 1)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func carouselSection(
        title: String,
        movies: [Movie],
        category: HomeCategory
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title, onSeeAll: {
                path.append(Route.category(category))
            })

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(movies) { movie in
                        NavigationLink(value: Route.detail(movie)) {
                            MovieCardView(path: movie.posterPath, size: .posterSmall)
                                .frame(width: 100, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview("Error") {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(networkService: MockNetworkService(shouldFail: true)), path: .constant(NavigationPath()), selectedTab: .constant(0))
    }
}

#Preview("Loaded") {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(networkService: MockNetworkService(shouldFail: false)), path: .constant(NavigationPath()), selectedTab: .constant(0))
    }
}
