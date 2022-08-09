//
//  TabBarCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit

enum SplashscreenState {
    case loading
    case success
    case failure

}

final class TabBarCoordinator: NSObject, TabBarNavigationCoordinator, UITabBarControllerDelegate {

    let homeCoordinator = HomepageCoordinator()
    
    let discoverCoordinator = DiscoverCoordinator()
    
    let searchCoordinator = SearchCoordinator()
    
    let downloadsCoordinator = DownloadsCoordinator()
    
    var tabBarController: UITabBarController
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .tabBarCoordinator }
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var state: SplashscreenState = .loading

    func start() {

        // NOTE: Adding all subcoordinators to the children array
        // children.append(homeCoordinator)
//        children.append(discoverCoordinator)
//        children.append(downloadsCoordinator)
//        children.append(downloadsCoordinator)

        // setUI()
        
        // NOTE: Starting all coordinators
       // homeCoordinator.start()
        
        switch state {
        case .loading:
            tabBarController.tabBar.isHidden = true
            tabBarController.viewControllers = [SplashscreenViewController()]
            homeCoordinator.start(coordinator: self) { result in
                self.state = result
                
                if self.state == .success {
                    self.homeCoordinator.startUI()
                    self.start()
                }
                
            }
            children.append(homeCoordinator)
            
            
            
        case .failure:
            print("C murio")
        case .success:
            self.setUI()
        }

    }
    
    override init() {
        tabBarController = UITabBarController()
        super.init()
        start()

    }
    
    func setUI() {
        var controllers: [UINavigationController] = []
        
        // NOTE: Adding all coordinators' viewControllers through UIBavigationController to show the navigationBar
        let homeViewController = UINavigationController(rootViewController: homeCoordinator.viewController!)
        homeViewController.tabBarItem = UITabBarItem(title: "Homepage", image: UIImage(systemName: "house"), tag: 0)

//        let discoverViewController = UINavigationController(rootViewController: discoverCoordinator.viewController)
//        discoverViewController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "play.circle"), tag: 1)
//
//        let searchViewController = UINavigationController(rootViewController: searchCoordinator.viewController)
//        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
//
//        let downloadsViewController = UINavigationController(rootViewController: downloadsCoordinator.viewController)
//        downloadsViewController.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 3)
        
        // NOTE: Adding all viewControllers to the controllers array
        controllers.append(homeViewController)
//        controllers.append(discoverViewController)
//        controllers.append(searchViewController)
//        controllers.append(downloadsViewController)
        
        // NOTE: Configuring tabBarController with UI enhancements, delegating and setting the viewControllers
        tabBarController.view.insetsLayoutMarginsFromSafeArea = true
        tabBarController.navigationController?.navigationBar.isTranslucent = true
        tabBarController.tabBar.isTranslucent = true
        tabBarController.delegate = self
        tabBarController.viewControllers = controllers
    }
    
}
