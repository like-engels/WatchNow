//
//  APImanager.swift
//  WatchNow
//
//  Created by User-D on 8/1/22.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(EndpointImplementation.getDiscoverFeed.baseUrl)/3/search/movie?api_key=\(EndpointImplementation.getDiscoverFeed.api_key)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.movies))
            } catch {
                completion(.failure(NetworkErrorManager.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<YoutubeVideo, Error>) -> Void) {
        
        var key: NSDictionary?
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            key = NSDictionary(contentsOfFile: path)
        }
        
        lazy var dict = key

        let apiKey = dict!["YoutubeAPIKey"] as! String
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrailerVideo.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(NetworkErrorManager.failedToGetData))
            }
        }
        task.resume()
    }
}
