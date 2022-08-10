//
//  DiscoverCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit
import Combine

final class DiscoverCoordinator : NSObject, Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var children: [Coordinator] = []
    var type: CoordinatorType { .simpleCoordinator }
    var viewController: UIViewController?
    
    // NOTE: Nonrelated to protocol stuff
    private var movies = [Movie]()
    private var cancellables = Set<AnyCancellable>()
    private let service = TheMovieDBNetworkAPIManagerImplementation.shared

    func start() {
        
    }
    
    func start(completion: @escaping (_ state: SplashscreenState) -> Void) {
        setUI { result in
            if result {
                completion(.success)
            } else {
                completion(.failure)
            }
        }
    }
    
    func startUI() {
        let discoverVC = DiscoverViewController(movies: self.movies)
        viewController = discoverVC
    }
    
    private func setUI(completion: @escaping (_ result: Bool) -> Void) {
        fetchUpcoming { result in
            if result {
                let discoverVC = DiscoverViewController(movies: self.movies)
                self.viewController = discoverVC
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func fetchUpcoming(completion: @escaping (_ result: Bool) -> Void) {
        let cancellable = self.service
            .request(from: .getDiscoverFeed)
            .sink { res in
                switch res {
                case .finished:
                    print(self.movies.count)
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] res in
                self?.movies = res.movies
            }
        self.cancellables.insert(cancellable)
    }

}
