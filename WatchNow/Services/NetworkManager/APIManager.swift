//
//  APImanager.swift
//  WatchNow
//
//  Created by User-D on 8/1/22.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

class APIManager {
    static let shared = APIManager()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getTrendingMovies.urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    func getTrendingSeries(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getTrendingSeries.urlRequest) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getUpcomingMovies.urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getPopularMovies.urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getTopRatedMovies.urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverFeed(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: EndpointImplementation.getDiscoverFeed.urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(EndpointImplementation.getDiscoverFeed.baseUrl)/3/search/movie?api_key=\(EndpointImplementation.getDiscoverFeed.api_key)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<YoutubeVideo, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=AIzaSyDGELlBDLQxZC7gio-GFJuNqo_DTIKgQTc") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrailerVideo.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
