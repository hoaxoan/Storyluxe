//
//  AppDelegate.swift
//  Storyluxe
//
//  Created by Sergey Koval on 29.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit
import SwiftyStoreKit

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

        // Complete Transactions
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                    UserDefaults.standard.set(true, forKey: isPurchaseUnlocked)
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        return true
    }

}

