//
//  HomepageCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit
import Combine

final class HomepageCoordinator : NSObject, Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var children: [Coordinator] = []
    var type: CoordinatorType { .simpleCoordinator }
    var viewController: UIViewController?
    
    // NOTE: I need to place all stored properties in a better place, I know, I think is not at all pretty to mix them with the protocol requirements
    private var randomSelectedMovieForHeaderBanner: Movie?
    private var cancellables = Set<AnyCancellable>()
    private var service = TheMovieDBNetworkAPIManagerImplementation.shared
    private var requestType: EndpointImplementation = .getTrendingMovies
    private var sectionsContent = [Sections.RawValue: [Movie]]()
    
    func start(coordinator: TabBarCoordinator, completion: @escaping (_ state: SplashscreenState) -> Void) {
//        getRandomMovie { result in
//            if result {
//                completion(.success)
//            } else {
//                completion(.failure)
//            }
//        }
        setUI { result in
            if result {
                completion(.success)
            } else {
                completion(.failure)
            }
        }
//        setUI()

    }
    
    func start() {
//        setUI()
    }
    
    func startUI() {
        let homeVC = HomepageViewController(randomMovieForBanner: randomSelectedMovieForHeaderBanner!, sectionContents: sectionsContent)
        viewController = homeVC
    }
    
//    private func setViewController() {
//        getRandomMovie()
//        getSections()
//    }
    
    func setUI(completion: @escaping (_ result: Bool) -> Void) {
        getRandomMovie { result in
            if result {
                let homeVC = HomepageViewController(randomMovieForBanner: self.randomSelectedMovieForHeaderBanner!, sectionContents: self.sectionsContent)
                self.viewController = homeVC
                
                completion(true)
            } else {
                completion(false)
            }
        }
       

    }
    
    private func getRandomMovie(completion: @escaping (_ result: Bool) -> Void) {
        let cancellable = self.service
            .request(from: .getTrendingMovies)
            .sink { res in
                switch res {
                case .finished:
                    self.getSections() { value in
                        completion(value)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            } receiveValue: { res in
                self.randomSelectedMovieForHeaderBanner = res.movies.randomElement()
            }
        self.cancellables.insert(cancellable)
    }
    
    private func getSections(completion: @escaping (_ result: Bool) -> Void) {
        for section in Sections.allCases {
            switch section {
            case .TrendingMovies:
                 fetchMoviesPerSections(.getTrendingMovies, section: .TrendingMovies) { value in
                    completion(value)
                }
            case .TrendingTV:
                 fetchMoviesPerSections(.getTrendingSeries, section: .TrendingTV) { value in
                    completion(value)
                }
            case .Popular:
                fetchMoviesPerSections(.getPopularMovies, section: .Popular) { value in
                    completion(value)
                }
            case .Upcoming:
                fetchMoviesPerSections(.getUpcomingMovies, section: .Upcoming) { value in
                    completion(value)
                }
            case .TopRated:
                fetchMoviesPerSections(.getTopRatedMovies, section: .TopRated) { value in
                    completion(value)
                }
            }
        }
    }

    private func fetchMoviesPerSections(_ requestType: EndpointImplementation, section: Sections, completion: @escaping (_ result: Bool) -> Void) {
        lazy var cancellable = self.service
            .request(from: requestType)
            .sink { res in
                switch res {
                case .finished:
                    if self.sectionsContent.count == Sections.allCases.count {
                        for (sectionName, sectionValue) in self.sectionsContent {
                            print("\(sectionName): \(sectionValue)")
                        }
                        completion(true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            } receiveValue: { movie in
                self.sectionsContent[section.rawValue] = movie.movies

            }
        self.cancellables.insert(cancellable)
    }

}
