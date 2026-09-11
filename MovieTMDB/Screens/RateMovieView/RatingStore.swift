//
//  RatingStore.swift
//  MovieTMDB
//
//  Created by Cicek on 11.09.26.
//

import Foundation

@Observable
final class RatingStore {
    private(set) var ratings: [Int: Double] = [:]
    private let fileURL: URL
    
    static var defaultFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("rating.json")
    }
    
    init( fileURL: URL = RatingStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }
    
    func rating(for movieId: Int) -> Double? {
        ratings[movieId]
    }
    
    func setRating(_ value: Double , for movieId: Int) {
        ratings[movieId] = value
        save()
    }
    
    
    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        ratings = (try? JSONDecoder().decode([Int: Double].self, from: data)) ?? [:]
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(ratings) else { return }
        try? data.write(to: fileURL,options: .atomic)
    }
}
