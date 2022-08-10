//
//  SearchCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit
import Combine

final class SearchCoordinator: NSObject, WorkflowCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var children: [Coordinator] = []
    var type: CoordinatorType { .simpleCoordinator }
    var viewController: UIViewController?

    //NOTE: Nonprotocol related stuff
    private var movies = [Movie]()
    private var cancellables = Set<AnyCancellable>()
    private var service = TheMovieDBNetworkAPIManagerImplementation.shared

    func start() {
        
    }

    func start(completion: @escaping (_ state: StateCompletion) -> Void) {
        setUI { result in
            if result {
                completion(.success)
            } else {
                completion(.error(.failed))
            }
        }
    }

    func startUI() {
        let searchVC = SearchViewController(movies: self.movies)
        viewController = searchVC
    }

    private func setUI(completion: @escaping (Bool) -> Void) {
        fetchDiscoverMovies { state in
            if state {
                let searchVC = SearchViewController(movies: self.movies)
                self.viewController = searchVC

                completion(true)
            } else {
                completion(false)
            }
        }
    }

    private func fetchDiscoverMovies(completion: @escaping (Bool) -> Void) {
        lazy var cancellable = self.service
            .request(from: .getTopRatedMovies)
            .sink { res in
                switch res {
                case .finished:
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            } receiveValue: { res in
                self.movies = res.movies
            }
        self.cancellables.insert(cancellable)
    }


}
