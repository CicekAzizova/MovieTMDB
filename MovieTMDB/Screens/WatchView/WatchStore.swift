//
//  Watch.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import Foundation

struct WatchMovie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let genreName: String?
    let releaseDate: String
    let runtime: Int?
}

@Observable
final class WatchStore {
    private(set) var favorites: [WatchMovie] = []

    private let fileURL: URL

    init(fileURL: URL = WatchStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }

    static var defaultFileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("watchlist.json")
    }

    func isFavorite(id: Int) -> Bool {
        favorites.contains { $0.id == id }
    }

    func toggle(_ movie: WatchMovie) {
        if isFavorite(id: movie.id) {
            remove(id: movie.id)
        } else {
            favorites.append(movie)
            save()
        }
    }

    func remove(id: Int) {
        favorites.removeAll { $0.id == id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        favorites = (try? JSONDecoder().decode([WatchMovie].self, from: data)) ?? []
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Watch list saxlanmadı: \(error.localizedDescription)")
        }
    }
}
