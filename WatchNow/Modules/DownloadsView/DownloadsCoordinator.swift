//
//  DownloadsCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit

final class DownloadsCoordinator : NSObject, Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var children: [Coordinator] = []
    var type: CoordinatorType { .simpleCoordinator }
    var viewController: UIViewController?
    
    // NOTE: Nonprotocol related stuff
    private var movies = [MovieItem]()
    
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
        let downloadsVC = DownloadsViewController(movies: self.movies)
        viewController = downloadsVC
    }
    
    private func setUI(completion: @escaping (Bool) -> Void) {
        fetchLocalStorageForDownload { result in
            if result {
                let downloadsVC = DownloadsViewController(movies: self.movies)
                self.viewController = downloadsVC
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func fetchLocalStorageForDownload(completion: @escaping (Bool) -> Void) {
        DataPersistenceManager.shared.fetchingMoviesFromCoreData { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                completion(true)
               // self.downloadsTable.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

}
