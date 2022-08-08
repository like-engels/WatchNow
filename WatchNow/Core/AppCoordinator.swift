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
    case unknown
}

class AppCoordinator: Coordinator {
    
    @Published var statusIndicator: String = "Loading"

    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .appCoordinator }
    
    func start() {
        launchMainScreen()
        // showSplashsreen()
    }
    
    func showSplashsreen() {
        let splashscreenViewController = SplashscreenViewController()
        navigationController?.pushViewController(splashscreenViewController, animated: false)
    }
    
    func launchMainScreen() {
        let mainViewController = rootTabBarViewController()
        navigationController?.pushViewController(mainViewController, animated: false)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

}
