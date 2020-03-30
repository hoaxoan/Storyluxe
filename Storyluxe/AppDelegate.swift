//
//  AppDelegate.swift
//  Storyluxe
//
//  Created by Sergey Koval on 29.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = blackTint
            let viewController = MainViewController()
            navController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }

        return true
    }

}

