//
//  HomeViewModel.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//
import Foundation

@Observable
final class HomeViewModel {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    var movies: [Movie] = []
    
    
    func fetchMovie() async {
        do {
            let decoderMovie: [Movie] = try await networkService.request(MovieEndPoint.popular(page: 1))
            movies = decoderMovie
        } catch is CancellationError {
            return
        }catch {
            //error.localizedDescription
        }
    }
    
}
