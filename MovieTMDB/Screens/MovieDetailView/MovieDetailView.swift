//
//  MovieDetailView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    @State private var viewModel = MovieDetailViewModel()

    @Environment(GenreStore.self) private var genreStore
    @Environment(WatchStore.self) private var watchStore
    @Environment(RatingStore.self) private var ratingStore

    @State private var selectedTab: DetailTab = .about

    @State private var isRatingPresented = false

    enum DetailTab: String, CaseIterable {
        case about = "About Movie"
        case reviews = "Reviews"
        case cast = "Cast"
    }

    init(movie: Movie, networkService: MovieNetworkService = DefaultMovieService()) {
        self.movie = movie
        _viewModel = State(initialValue: MovieDetailViewModel(networkService: networkService))
    }

    var body: some View {
        ZStack {
            content
                .navigationTitle("Detail")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        bookmarkButton
                    }
                }
                .task(id: movie.id) {
                    await viewModel.load(id: movie.id)
                }
                .blur(radius: isRatingPresented ? 12 : 0)
                .allowsHitTesting(!isRatingPresented)

            if isRatingPresented {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { }

                VStack {
                    Spacer()
                    RateMovieView(movie: movie, isPresented: $isRatingPresented)
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
                
        }
        .toolbar(isRatingPresented ? .hidden : .visible, for: .tabBar)
        .animation(.easeInOut(duration: 0.3), value: isRatingPresented)
    }

    // MARK: - Top-level state switch (loading/empty/error/loaded)

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")

        case .empty:
            ContentUnavailableView(
                "Not Found",
                systemImage: "film",
                description: Text("Movie details could not be found")
            )

        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.load(id: movie.id)
                    }
                }
            }

        case .loaded:
            loadedContent
        }
    }

    private var loadedContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                heroSection

                if let detail = viewModel.detail {
                    titleSection(detail: detail)
                    infoRow(detail: detail)

                    if let director = viewModel.director {
                        Text("Director: \(director)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                    }
                }

                tabPicker
                tabContent

                if !viewModel.similarMovies.isEmpty {
                    similarSection
                }
            }
        }
    }

    private var bookmarkButton: some View {
        Button {
            guard let detail = viewModel.detail else { return }
            watchStore.toggle(
                WatchMovie(
                    id: detail.id,
                    title: detail.title,
                    posterPath: detail.posterPath,
                    voteAverage: detail.voteAverage,
                    genreName: detail.genres.first?.name,
                    releaseDate: detail.releaseDate,
                    runtime: detail.runtime
                )
            )
        } label: {
            Image(systemName: watchStore.isFavorite(id: movie.id) ? "bookmark.fill" : "bookmark")
        }
    }

    // MARK: - Hero (backdrop + poster + rating badge)

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            MovieCardView(path: movie.backdropPath, size: .backdropLarge)
                .frame(maxWidth: .infinity)
                .frame(height: 210)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 24,
                        bottomTrailingRadius: 24,
                        topTrailingRadius: 0
                    )
                )
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        isRatingPresented = true
                    } label: {
                        ratingBadge
                            .padding(12)
                    }
                }

            MovieCardView(path: movie.posterPath, size: .posterSmall)
                .frame(width: 95, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 2)
                )
                .padding(.leading, 16)
                .offset(y: 40)
        }
        .padding(.bottom, 40)
    }

    private var ratingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.orange)
            Text(String(format: "%.1f", ratingStore.rating(for: movie.id) ?? movie.voteAverage))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Title + info row

    private func titleSection(detail: MovieDetail) -> some View {
        Text(detail.title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal, 16)
    }

    private func infoRow(detail: MovieDetail) -> some View {
        HStack(spacing: 16) {
            if !detail.releaseDate.isEmpty {
                Label(String(detail.releaseDate.prefix(4)), systemImage: "calendar")
            }
            if let runtime = detail.runtime {
                Label("\(runtime) Minutes", systemImage: "clock")
            }
            if let firstGenre = detail.genres.first {
                Label(firstGenre.name, systemImage: "person.2")
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
    }

    // MARK: - Tabs

    private var tabPicker: some View {
        HStack {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .bold : .regular)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(alignment: .bottom) {
                            if selectedTab == tab {
                                Rectangle()
                                    .frame(height: 2)
                            }
                        }
                }
                .buttonStyle(.plain)
                .foregroundStyle(selectedTab == tab ? .primary : .secondary)
            }
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .about:
            aboutSection
        case .reviews:
            ReviewsSectionView(reviews: viewModel.reviews)
        case .cast:
            CastSectionView(cast: viewModel.credits?.cast ?? [])
        }
    }

    // MARK: - About tab

    private var aboutSection: some View {
        Group {
            if let detail = viewModel.detail {
                VStack(alignment: .leading, spacing: 8) {
                    if let tagline = detail.tagline, !tagline.isEmpty {
                        Text(tagline)
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                    Text(detail.overview)
                        .font(.body)
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Similar movies

    private var similarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Similar Movies")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(viewModel.similarMovies) { similar in
                        NavigationLink(value: Route.detail(similar)) {
                            MovieCardView(path: similar.posterPath, size: .posterSmall)
                                .frame(width: 100, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 16)
    }
}

#Preview("Loaded") {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 1,
                title: "Spider-Man: No Way Home",
                overview: "Test overview",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: "2021-12-15",
                voteAverage: 9.5,
                voteCount: 100,
                genreIds: [28]
            ),
            networkService: MockNetworkService(shouldFail: false)
        )
    }
    .environment(GenreStore())
    .environment(WatchStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview.json")))
}

#Preview("Error") {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 1,
                title: "Spider-Man: No Way Home",
                overview: "Test overview",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: "2021-12-15",
                voteAverage: 9.5,
                voteCount: 100,
                genreIds: [28]
            ),
            networkService: MockNetworkService(shouldFail: true)
        )
    }
    .environment(GenreStore())
    .environment(WatchStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview.json")))
}
