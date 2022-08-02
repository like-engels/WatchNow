//
//  URL+AppendingQueryParameters.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 1/8/22.
//

import Foundation

public extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }

}
