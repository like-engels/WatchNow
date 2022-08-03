//
//  NetworkAPIManager.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 2/8/22.
//

import Foundation
import Combine

protocol NetworkAPIManagerBuilder {
    func request(from endpoint: EndpointImplementation) -> AnyPublisher<Movies, NetworkErrorManager>
}

class TheMovieDBNetworkAPIManagerImplementation: NetworkAPIManagerBuilder {
    func request(from endpoint: EndpointImplementation) -> AnyPublisher<Movies, NetworkErrorManager> {
        
        let decoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<Movies, NetworkErrorManager> in
                guard let response = response as? HTTPURLResponse else { return
                    Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: Movies.self, decoder: decoder)
                        .mapError { _ in .decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
                
            }
            .eraseToAnyPublisher()
    }

}

