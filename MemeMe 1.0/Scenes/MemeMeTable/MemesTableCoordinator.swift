//
//  MemesTableCoordinator.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class MemesTableCoordinator: Coordinator {
    
    private var navigationController: UINavigationController!
    
    override init() { }
    
    override func start() {
        let vc = MemesTableViewController()
        vc.delegate = self
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "table")!, tag: 0)
        self.rootViewController = navigationController
    }
}

extension MemesTableCoordinator: MemesTableViewDelegate {
    func didShowMemeEditor() { 
        let vc = MemeEditorViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MemesTableCoordinator: MemeEditorDelegate {
    func didCancel() {
        navigationController.popViewController(animated: true)
    }
}
