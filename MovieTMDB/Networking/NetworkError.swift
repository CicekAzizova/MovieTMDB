//
//  HttpMethod.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidUrl
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case encodingError
    case unknown(Error)
    
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL duzgun deyil"
        case .invalidResponse:
            return "Server response duzgun deyil"
        case .serverError(let statusCode):
            return "Server xetasi: \(statusCode)"
        case .decodingError:
            return "Decoding xetasi"
        case .encodingError:
            return "Encoding xetasi"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
