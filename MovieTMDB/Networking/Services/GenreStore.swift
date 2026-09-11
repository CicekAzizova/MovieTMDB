//
//  GenreStore.swift
//  MovieTMDB
//
//  Created by Cicek on 08.09.26.
//
import Foundation

@Observable
final class GenreStore {
    private(set) var genresById: [Int: String] = [:]
    private let networkService: MovieNetworkService
    
    init(networkService: MovieNetworkService = DefaultMovieService()) {
        self.networkService = networkService
    }
    
    func loadNeeded() async {
        guard genresById.isEmpty else { return }
        
        do {
            let response = try await networkService.fetchGenreList()
            genresById = Dictionary(uniqueKeysWithValues: response.genres.map{ ($0.id , $0.name)})
        } catch {
            print("Genre list yüklənmədi: \(error.localizedDescription)")
        }
    }
    
    func names(for ids: [Int]) -> String {
        ids.compactMap { genresById[$0]}.joined(separator: ", ")
    }
}
