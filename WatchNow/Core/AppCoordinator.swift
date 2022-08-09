//
//  AppCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

enum SplashscreenState {
    case loading
    case success
    case failure

}

class AppCoordinator: NSObject, NavigationCoordinator {

    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .appCoordinator }
    
    var state: SplashscreenState = .success
    
    func start() {
        switch state {
        case .loading:
            splashscreenState()
        case .success:
            successState()
        case .failure:
            failureState()
            
        }
    }
    
    func splashscreenState() {
        let splashscreenViewController = SplashscreenViewController()
        navigationController?.pushViewController(splashscreenViewController, animated: false)
    }
    
    func successState() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        children.append(tabBarCoordinator)
        navigationController?.pushViewController(tabBarCoordinator.tabBarController, animated: false)
    }
    
    func failureState() {}
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

}
