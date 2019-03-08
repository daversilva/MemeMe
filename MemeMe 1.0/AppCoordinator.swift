//
//  AppCoordinator.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 07/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    private var navigationController: UINavigationController!
    
    override init() {
        super.init()
    }
    
    override func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        store(coordinator: mainCoordinator)
        self.rootViewController = mainCoordinator.rootViewController
    }
}
