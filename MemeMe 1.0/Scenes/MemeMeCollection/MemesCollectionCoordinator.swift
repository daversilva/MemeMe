//
//  MemesCollectionCoordinator.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class MemesCollectionCoordinator: Coordinator {
    
    private var navigationController: UINavigationController!
    
    override init() { }
    
    override func start() {
        let vc = MemesCollectionViewController()
        vc.delegate = self
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "collection")!, tag: 1)
        self.rootViewController = navigationController
    }
}

extension MemesCollectionCoordinator: MemesCollectionViewDelegate {
    
    func didShowMemeDetail(for meme: Meme) {
        let vc = MemeDetailViewController()
        vc.meme = meme
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didShowMemeEditor() {
        let vc = MemeEditorViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MemesCollectionCoordinator: MemeEditorDelegate {
    func didCancel() {
        navigationController.popViewController(animated: true)
    }
}
