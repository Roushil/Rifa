//
//  EndPointType.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 10/11/23.
//

import Foundation

//enum DataError: Error {
//    case invalidResponse
//    case invalidURL
//    case invalidData
//    case network
//}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
}

enum EndPointItems {
    case userProfile
    case search
    case searchResults
}


extension EndPointItems : EndPointType {
    
    var path: String {
        get {
            switch self {
            case .userProfile:
                return "user-profile/"
            case .search:
                return "demo/search/"
            case .searchResults:
                return "demo/search-results/"
            }
        }
    }
    
    var baseURL: String {
        return "http://13.52.112.56:8000/api/v1/app/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .userProfile:
            return .get
        case .search:
            return .post
        case .searchResults:
            return .get
        }
    }
}
