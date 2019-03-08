//
//  Coordinator.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 07/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorDelegate: class {
    func didFinish(coordinator: Coordinator)
}

class Coordinator {
    
    var childCoordinators = [UUID: Coordinator]()
    var rootViewController: UIViewController? = nil
    var isAnimated: Bool = true
    
    let identifier = UUID()
    
    func start() {
        fatalError("this method should be overrided")
    }
    
    func store(coordinator: Coordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators[coordinator.identifier]?.rootViewController?.dismiss(animated: false, completion: nil)
        childCoordinators[coordinator.identifier] = nil
    }
    
    deinit {
        childCoordinators.forEach { key, value in
            free(coordinator: value)
        }
    }
    
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs.identifier == lhs.identifier
    }
}
