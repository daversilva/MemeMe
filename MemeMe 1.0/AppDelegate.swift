//
//  AppDelegate.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 02/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    var memes = BehaviorRelay<[Meme]>(value: [])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        startApp()
        
        return true
    }

}

/// MARK :- Custom methods
extension AppDelegate {
    
    func startApp() {
        coordinator = AppCoordinator()
        coordinator?.start()
        window?.rootViewController = coordinator?.rootViewController
        window?.makeKeyAndVisible()
    }
    
}
