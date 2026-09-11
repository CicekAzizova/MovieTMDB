//
//  DefaultNetworkService.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import Foundation

nonisolated final class DefaultNetworkService: NetworkService {
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
            
            if (200...299).contains(httpResponse.statusCode) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoderdata = try decoder.decode(T.self, from: data)
                return decoderdata
            }else if httpResponse.statusCode == 401   {
                throw NetworkError.unauthorized
            } else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
        } catch let networkError as NetworkError {
            throw networkError
        }catch {
            throw NetworkError.unknown(error)
        }
    }
}
