//
//  NetworkManager.swift
//  WatchNow
//
//  Created by User-D on 8/1/22.
//

import Foundation

enum NetworkErrorManager: Error {
    case decodingError
    case errorCode(Int)
    case failedToGetData
    case unknown
}

extension NetworkErrorManager: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the error from the service"
        case .errorCode(let code):
            return "\(code) - Something went wrong"
        case .failedToGetData:
            return "Failed to get data"
        case .unknown:
            return "The error is unknown"
        }
    }
}
