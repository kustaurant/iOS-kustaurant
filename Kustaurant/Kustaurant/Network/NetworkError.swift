//
//  NetworkError.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidRequest
    case noData
    case decodingFailed
    case unknown
    case custom(String)
    case unauthorized
    case serverError(statusCode: Int)
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidRequest:
            return "Invalid Request"
        case .unauthorized:
            return "Unauthrized API Request, Access Token might be invalid"
        case .noData:
            return "No data received"
        case .decodingFailed:
            return "Failed to decode the data"
        case .unknown:
            return "An unknown error occurred"
        case .custom(let message):
            return message
        case .serverError(let statusCode):
            return "\(statusCode)"
        }
    }
}
