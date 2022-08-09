//
//  DiscoverCoordinator.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/8/22.
//

import UIKit

final class DiscoverCoordinator : NSObject, Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    
    var type: CoordinatorType { .simpleCoordinator }
    
    let viewController = DiscoverViewController()
    
    func start() {
        
    }

}
