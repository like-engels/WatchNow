//
//  TabBarCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit

final class TabBarCoordinator: NSObject, TabBarNavigationCoordinator, UITabBarControllerDelegate {
    // NOTE: All coordinators instances
    var homeCoordinator = HomepageCoordinator()
    var discoverCoordinator = DiscoverCoordinator()
    var searchCoordinator = SearchCoordinator()
    var downloadsCoordinator = DownloadsCoordinator()
    var stateManager = StateManagerImpl()

    // NOTE: Protocol-related stuff
    var tabBarController: UITabBarController
    var children: [Coordinator] = []
    var type: CoordinatorType { .tabBarCoordinator }
    var finishDelegate: CoordinatorFinishDelegate?
    var stateManagerStatus: StateCompletion = .loading

    func start() {
        switch stateManagerStatus {
        case .loading:
            tabBarController.tabBar.isHidden = true
            tabBarController.viewControllers = [SplashscreenViewController()]
            
            if case .success = self.stateManagerStatus {
                self.setUI()
                self.stateManager.free()
            }

            prepareHomeCoordinator()

        case .error(.someCoordinatorFailed):
            print("C murio")
        case .success:
            tabBarController.tabBar.isHidden = false
            self.setUI()
        case .error(.emptyCoordinators):
            print("empty coordinator")
        case .error(.failed):
            print("something went wrong")
        case .error(.unknown):
            print("unknown error")
        }
        
    }
    
    override init() {
        tabBarController = UITabBarController()
        super.init()
        start()

    }
    
    private func prepareHomeCoordinator() {
        stateManager.sink(coordinator: homeCoordinator) { completion in
            switch completion {
            case .loading:
                print("loading coordinator")
            case .error(let error):
                print(error)
            case .success:
                self.stateManagerStatus = completion
                self.prepareDiscoverCoordinator()
            }
        } sinked: { coordinator in
            self.homeCoordinator = coordinator as! HomepageCoordinator
        }
    }
    
    private func prepareDiscoverCoordinator() {
        stateManager.sink(coordinator: discoverCoordinator) { completion in
            switch completion {
            case .loading:
                print("loading coordinator")
            case .error(let error):
                print(error)
            case .success:
                self.stateManagerStatus = completion
                self.prepareSearchCoordinator()
            }
        } sinked: { coordinator in
            self.discoverCoordinator = coordinator as! DiscoverCoordinator
        }

    }
    
    private func prepareSearchCoordinator() {
        stateManager.sink(coordinator: searchCoordinator) { completion in
            switch completion {
            case .loading:
                print("loading coordinator")
            case .error(let error):
                print(error)
            case .success:
                self.stateManagerStatus = completion
                self.prepareDownloadsCoordinator()
            }
        } sinked: { coordinator in
            self.searchCoordinator = coordinator as! SearchCoordinator
        }
        
    }
    
    private func prepareDownloadsCoordinator() {
        stateManager.sink(coordinator: downloadsCoordinator) { completion in
            switch completion {
            case .loading:
                print("loading coordinator")
            case .error(let error):
                print(error)
            case .success:
                self.stateManagerStatus = completion
                self.stateManager.free()
                self.start()
            }
        } sinked: { coordinator in
            self.downloadsCoordinator = coordinator as! DownloadsCoordinator
        }

    }
    
    func setUI() {
        var controllers: [UINavigationController] = []
        
//         NOTE: Adding all coordinators' viewControllers through UIBavigationController to show the navigationBar
        let homeViewController = UINavigationController(rootViewController: homeCoordinator.viewController!)
        homeViewController.tabBarItem = UITabBarItem(title: "Homepage", image: UIImage(systemName: "house"), tag: 0)

        let discoverViewController = UINavigationController(rootViewController: discoverCoordinator.viewController!)
        discoverViewController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "play.circle"), tag: 1)

        let searchViewController = UINavigationController(rootViewController: searchCoordinator.viewController!)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let downloadsViewController = UINavigationController(rootViewController: downloadsCoordinator.viewController!)
        downloadsViewController.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 3)
        
//         NOTE: Adding all viewControllers to the controllers array
        controllers.append(homeViewController)
        controllers.append(discoverViewController)
        controllers.append(searchViewController)
        controllers.append(downloadsViewController)
        
        // NOTE: Configuring tabBarController with UI enhancements, delegating and setting the viewControllers
        tabBarController.view.insetsLayoutMarginsFromSafeArea = true
        tabBarController.navigationController?.navigationBar.isTranslucent = true
        tabBarController.tabBar.isTranslucent = true
        tabBarController.delegate = self
        tabBarController.viewControllers = controllers
    }
    
}
