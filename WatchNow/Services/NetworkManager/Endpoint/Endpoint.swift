//
//  Endpoints.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 1/8/22.
//

import Foundation

protocol EndpointBuilder {
    var api_key: String { get }
    var baseUrl: URL { get }
    var path: String { get }
    var query: [String: String] { get }
    var urlRequest: URLRequest { get }
}

enum EndpointImplementation: String {
    case getTrendingSeries
    case getTrendingMovies
    case getUpcomingMovies
    case getPopularMovies
    case getTopRatedMovies
    case getDiscoverFeed
    
}

extension EndpointImplementation: EndpointBuilder {
    var api_key: String {
        switch self {
        case .getTrendingMovies, .getTrendingSeries, .getUpcomingMovies, .getPopularMovies, .getTopRatedMovies, .getDiscoverFeed:
            var keys: NSDictionary?
            if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
                keys = NSDictionary(contentsOfFile: path)
            }
            
            lazy var dict = keys
            let apiKey = dict!["TheMovieDBKey"] as? String
            return apiKey!
        }
    }
    
    var baseUrl: URL {
        switch self {
        case .getTrendingMovies, .getTrendingSeries, .getUpcomingMovies, .getPopularMovies, .getTopRatedMovies, .getDiscoverFeed:
            return URL(string: "https://api.themoviedb.org")!
        }
    }
    
    var path: String {
        switch self {
        case .getTrendingMovies:
            return "/3/trending/movie/day"
        case .getTrendingSeries:
            return "/3/trending/tv/day"
        case .getUpcomingMovies:
            return "/3/movie/upcoming"
        case .getPopularMovies:
            return "/3/movie/popular"
        case .getTopRatedMovies:
            return "/3/movie/top_rated"
        case .getDiscoverFeed:
            return "/3/discover/movie"
        }
    }
    
    var query: [String: String] {
        switch self {
        case .getTrendingMovies, .getTrendingSeries, .getUpcomingMovies, .getPopularMovies, .getTopRatedMovies, .getDiscoverFeed:
            return ["api_key": self.api_key]
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getTrendingMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
        case .getTrendingSeries:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
        case .getUpcomingMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
        case .getPopularMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
        case .getTopRatedMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
        case .getDiscoverFeed:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters(self.query))
            
        }
    }
}
