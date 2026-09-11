//
//  WatchListView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import SwiftUI

struct WatchListView: View {
    @Environment(WatchStore.self) private var watchStore

    var body: some View {
        Group {
            if watchStore.favorites.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(watchStore.favorites) { watch in
                        MovieDetailHeaderView(
                            path: watch.posterPath,
                            title: watch.title,
                            voteAverage: watch.voteAverage,
                            genres: watch.genreName ?? "",
                            releaseDate: watch.releaseDate,
                            runtime: watch.runtime
                        )
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                watchStore.remove(id: watch.id)
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Watch list")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(.emptyWatch)

            Text("There Is No Movie Yet!")
                .font(.title3)
                .fontWeight(.bold)

            Text("Find your movie by Type title, categories, years, etc")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview("Dolu") {
    NavigationStack {
        WatchListView()
    }
    .environment({
        let store = WatchStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview.json"))
        store.toggle(WatchMovie(id: 1, title: "Spiderman", posterPath: nil, voteAverage: 9.5, genreName: "Action", releaseDate: "2019-06-28", runtime: 139))
        return store
    }())
}

#Preview("Boş") {
    NavigationStack {
        WatchListView()
    }
    .environment(WatchStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview-empty.json")))
}
