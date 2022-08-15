//
//  StateManagerImplementation.swift
//  WatchNow
//
//  Created by User-D on 8/10/22.
//

import Foundation

class StateManagerImpl: StateManager {
    var coordinator: WorkflowCoordinator?
    
    var coordinators: [WorkflowCoordinator] = [WorkflowCoordinator]()
    
    var sinkedCoordinators: [WorkflowCoordinator] = [WorkflowCoordinator]()
    
}
