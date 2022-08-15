//
//  AppCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

class AppCoordinator: NSObject, NavigationCoordinator {

    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .appCoordinator }
        
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        children.append(tabBarCoordinator)
        navigationController?.pushViewController(tabBarCoordinator.tabBarController, animated: false)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

}
