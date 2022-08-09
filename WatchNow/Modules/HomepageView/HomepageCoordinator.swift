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
    let viewController = HomepageViewController()
    
    // NOTE: I need to place all stored properties in a better place, I know, I think is not at all pretty to mix them with the protocol requirements
    private var randomSelectedMovieForHeaderBanner: Movie?
    private var cancellables = Set<AnyCancellable>()
    private var service = TheMovieDBNetworkAPIManagerImplementation.shared
    private var requestType: EndpointImplementation = .getTrendingMovies
    private var sectionsContent = [Sections.RawValue: Movies]()
    
    func start() {
        getRandomMovie()
    }
    
    private func getRandomMovie() {
        let cancellable = self.service
            .request(from: .getTrendingMovies)
            .sink { res in
                switch res {
                case .finished:
                    print("Finished owo")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { res in
                self.randomSelectedMovieForHeaderBanner = res.movies.randomElement()
            }
        self.cancellables.insert(cancellable)
    }
    
    private func fetchMoviesPerSections(_ requestType: EndpointImplementation, section: Sections) {
        lazy var cancellable = self.service
            .request(from: requestType)
            .receive(on: DispatchQueue.main)
            .sink { res in
            } receiveValue: { movie in
                self.sectionsContent[section.rawValue] = movie
            }
        self.cancellables.insert(cancellable)
    }

}
