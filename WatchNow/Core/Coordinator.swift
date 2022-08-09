//
//  Coordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

enum CoordinatorType {
    case appCoordinator
    case tabBarCoordinator
    case navigationCoordinator
    case simpleCoordinator
}

protocol Coordinator: NSObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }

    var children: [Coordinator] { get set }

    var type: CoordinatorType { get }

    func start()

    func finish()

}

extension Coordinator {
    func finish() {
        children.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController? { get set }
}

protocol TabBarNavigationCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
