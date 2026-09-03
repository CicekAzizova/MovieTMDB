//
//  DefaultNetworkService.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import Foundation

final class DefaultNetworkService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: any EndPoint) async throws -> T {
        do {
            let request = try endpoint.makeRequest()
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            let decoderdata = try JSONDecoder().decode(T.self, from: data)
            return decoderdata
        } catch let networkError as NetworkError {
            throw networkError
        }catch {
            throw NetworkError.unknown(error)
        }
    }
    
   
}
