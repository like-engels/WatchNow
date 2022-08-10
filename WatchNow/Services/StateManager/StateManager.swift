//
//  StateManager.swift
//  WatchNow
//
//  Created by User-D on 8/10/22.
//

import Foundation

enum StateCompletion {
    case loading
    case error(StateError)
    case success
}

enum StateError {
    case emptyCoordinators
    case someCoordinatorFailed
    case failed
    case unknown
}

protocol StateManager: NSObject {
    var coordinators: [WorkflowCoordinator] { get set }
    
    var coordinatorCounter: Int { get set }
    
    func start(coordinators: [WorkflowCoordinator], sink: @escaping ([WorkflowCoordinator]) -> Void, completion: @escaping (StateCompletion) -> Void)
    
    func add(coordinator: [WorkflowCoordinator])
    
    func free()
    
}

extension StateManager {
    func add(coordinator: [WorkflowCoordinator]) {
        self.coordinators.append(contentsOf: coordinator)
    }
    
    func free() {
        self.coordinators.removeAll()
    }
    
    func sink(coordinators: @escaping ([WorkflowCoordinator]) -> Void , completion: @escaping (StateCompletion) -> Void) {
        if self.coordinators.isEmpty {
            completion(.error(.emptyCoordinators))
        }
        
        if self.coordinatorCounter == self.coordinators.count {
            coordinators(self.coordinators)
            completion(.success)
        }
    }

}
