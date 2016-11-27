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
    let mapViewController: MapViewController
    
    init(tabBarController: UITabBarController) {
        sessionsViewController = tabBarController.tabInNavigationController(atIndex: 0) as SessionsViewController
        starredSessionsViewController = tabBarController.tabInNavigationController(atIndex: 1) as SessionsViewController
        speakersViewController = tabBarController.tabInNavigationController(atIndex: 2) as SpeakersViewController
        mapViewController = tabBarController.tab(atIndex: 3) as MapViewController
        
        self.tabBarController = tabBarController
    }
    
    func start() {
        sessionsViewController.title = NSLocalizedString("Sessions", comment: "tab title")
        starredSessionsViewController.title = NSLocalizedString("Your Schedule", comment: "tab title")
        starredSessionsViewController.shouldShowStarredOnly = true
        speakersViewController.title = NSLocalizedString("Speakers", comment: "tab title")
        mapViewController.title = NSLocalizedString("Map", comment: "tab title")
    }
}

private extension UITabBarController {
    func tab<ViewController: UIViewController>(atIndex index: Int) -> ViewController {
        let vc = viewControllers![index] as! ViewController
        return vc
    }
    
    func tabInNavigationController<ViewController: UIViewController>(atIndex index: Int) -> ViewController {
        let navController = viewControllers![index] as! UINavigationController
        let vc = navController.viewControllers[0] as! ViewController
        return vc
    }
}
