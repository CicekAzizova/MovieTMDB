//
//  EndPoint.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//
import Foundation

protocol EndPoint {
    
    var path: String { get }
    var method: HttpMethod { get }
    
    var queryItems: [URLQueryItem]? { get }
    var httpBody: Encodable? { get }
}

extension EndPoint {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var headers: [String: String]? {
        [
            HttpHeader.authorization: "Bearer \(APIConfig.accessToken)",
            HttpHeader.accept: Accept.json
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var httpBody: Encodable? {
        return nil
    }
}


extension EndPoint {
    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidUrl
        }
        
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        headers?.forEach { key , value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let httpBody {
            do {
                request.httpBody = try JSONEncoder().encode(httpBody)
            } catch  {
                throw NetworkError.encodingError
            }
        }
        
        return request
    }
}
