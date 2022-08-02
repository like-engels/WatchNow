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
    var query: String { get }
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
            return "a7c653195b0d9633df4a71ac8a2b4e8e"
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
    
    var query: String {
        switch self {
        case .getTrendingMovies, .getTrendingSeries, .getUpcomingMovies, .getPopularMovies, .getTopRatedMovies, .getDiscoverFeed:
            return "api_key"
        }
    }

    var urlRequest: URLRequest {
        switch self {
        case .getTrendingMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        case .getTrendingSeries:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        case .getUpcomingMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        case .getPopularMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        case .getTopRatedMovies:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        case .getDiscoverFeed:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path).appendingQueryParameters([self.query: self.api_key]))
        }
    }
}
