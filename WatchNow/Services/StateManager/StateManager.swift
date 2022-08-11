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

protocol StateManager: AnyObject {
    var coordinator: WorkflowCoordinator? { get set }
    var coordinators: [WorkflowCoordinator] { get set }
    var sinkedCoordinators: [WorkflowCoordinator] { get set }
    
    func sink(coordinator: WorkflowCoordinator, completion: @escaping (StateCompletion) -> Void, sinked: @escaping (WorkflowCoordinator) -> Void)
    
    func append(coordinator: WorkflowCoordinator)
    
    func free()

}

extension StateManager {
    func sink(coordinator: WorkflowCoordinator, completion: @escaping (StateCompletion) -> Void, sinked: @escaping (WorkflowCoordinator) -> Void) {
        coordinator.start { state in
            switch state {
            case .loading:
                print("is loading")
            case .error(let stateError):
                print(stateError)
            case .success:
                self.sinkedCoordinators.append(coordinator)
                completion(.success)
                sinked(coordinator)
            }
        }
    }
    
    func append(coordinator: WorkflowCoordinator) {
        self.coordinators.append(coordinator)
    }
    
    func free() {
        self.coordinators.removeAll()
        self.sinkedCoordinators.removeAll()
        self.coordinator = nil
    }
}
