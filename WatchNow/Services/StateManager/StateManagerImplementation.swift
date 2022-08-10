//
//  StateManagerImplementation.swift
//  WatchNow
//
//  Created by User-D on 8/10/22.
//

import Foundation

class StateManagerImplementation: NSObject, StateManager {
    var coordinators: [WorkflowCoordinator] = []
    var coordinatorCounter: Int = 0

    func start(coordinators: [WorkflowCoordinator], sink: @escaping ([WorkflowCoordinator]) -> Void, completion: @escaping (StateCompletion) -> Void) {
        for coordinator in coordinators {
            coordinator.start { state in
                switch state {
                case .success:
                    self.coordinatorCounter = self.coordinatorCounter + 1
                case .loading:
                    print("loading coordinator")
                case .error(let stateError):
                    print(stateError)
                }
            }
        }
        
        print(self.coordinatorCounter)
        
        if self.coordinatorCounter == self.coordinators.count {
            sink(self.coordinators)
            completion(.success)
        }
    }
    
    override init() {
        super.init()
    }
    
}
