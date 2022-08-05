//
//  AppCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .appCoordinator }
    
    func start() {

    }
    
    func showSplashsreen() {
        
    }
    
    func launchMainScreen() {
        
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

}
