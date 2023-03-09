//
//  HttpClient.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/3/23.
//

import Foundation
import Combine

class HttpClient {
    static let shared = HttpClient()
    
    func request<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func rawRequest(from url: URLRequest) -> Future<[String: Any], Error> {
        return Future { promise in
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(NSError(domain: "", code: -1)))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dictionary = json as? [String: Any] else {
                        promise(.failure(NSError(domain: "", code: -1)))
                        return
                    }
                    
                    promise(.success(dictionary))
                } catch let error {
                    promise(.failure(error))
                }
            }
            .resume()
        }
    }
}

