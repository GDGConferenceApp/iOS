//
//  AppDelegate.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var tabController: UITabBarController!
    private lazy var appCoordinator: AppCoordinator = { () -> AppCoordinator in
        return AppCoordinator(tabBarController: self.tabController)
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        tabController = window!.rootViewController as! UITabBarController
        appCoordinator.start()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            // TODO: Consider moving this to the AppCoordinator or the FirebaseCoordinator
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

}

