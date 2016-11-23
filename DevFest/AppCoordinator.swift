//
//  AppCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {
    let tabBarController: UITabBarController
    
    let sessionsViewController: SessionsViewController
    let starredSessionsViewController: SessionsViewController
    let speakersViewController: SpeakersViewController
    
    init(tabBarController: UITabBarController) {
        sessionsViewController = tabBarController.tabInNavigationController(atIndex: 0) as SessionsViewController
        starredSessionsViewController = tabBarController.tabInNavigationController(atIndex: 1) as SessionsViewController
        speakersViewController = tabBarController.tabInNavigationController(atIndex: 2) as SpeakersViewController
        
        self.tabBarController = tabBarController
    }
    
    func start() {
        sessionsViewController.title = "Sessions"
        starredSessionsViewController.title = "Your Schedule"
        starredSessionsViewController.shouldShowStarredOnly = true
        speakersViewController.title = "Speakers"
    }
}

private extension UITabBarController {
    func tabInNavigationController<ViewController: UIViewController>(atIndex index: Int) -> ViewController {
        let navController = viewControllers![index] as! UINavigationController
        let vc = navController.viewControllers[0] as! ViewController
        return vc
    }
}
