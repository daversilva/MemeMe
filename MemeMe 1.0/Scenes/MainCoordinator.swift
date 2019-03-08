//
//  MainCoordinator.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 07/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    private var tabBarController: UITabBarController!
    
    let memeTableCoordinator: MemesTableCoordinator
    let memeCollectionCoordinator: MemesCollectionCoordinator
    
    override init() {
        self.tabBarController = UITabBarController()
        self.memeTableCoordinator = MemesTableCoordinator()
        self.memeCollectionCoordinator = MemesCollectionCoordinator()
        super.init()
        self.rootViewController = tabBarController
    }
    
    override func start() {
        let coordinators: [Coordinator] = [
            memeTableCoordinator,
            memeCollectionCoordinator
        ]
        
        coordinators.forEach { coordinator in
            store(coordinator: coordinator)
            coordinator.start()
        }
        
        tabBarController.viewControllers = coordinators.compactMap { $0.rootViewController }
    }
}
