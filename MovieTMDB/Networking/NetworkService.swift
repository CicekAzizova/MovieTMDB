//
//  HttpMethod.swift
//  MovieTMDB
//
//  Created by Cicek on 01.09.26.
//
import Foundation

protocol NetworkService {
    func request<T:Decodable>(_ endpoint: EndPoint) async throws -> T
}
