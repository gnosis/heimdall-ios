//
//  Coordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 20.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

class Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func add(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    func remove(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.index(of: childCoordinator) else { return }
        childCoordinators.remove(at: index)
    }
    
    func start() {
        die("Coordinator.start() needs to be overridden.")
    }
}

// MARK: - Equatable
extension Coordinator: Equatable {
    static func ==(lhs: Coordinator, rhs: Coordinator) -> Bool {
        // We do not really care about content equality, so we just check for reference equality.
        return lhs === rhs
    }
}
