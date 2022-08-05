//
//  Coordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

enum CoordinatorType {
    case appCoordinator
    case tabCoordinator
    case commonCoordinator
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }

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

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
