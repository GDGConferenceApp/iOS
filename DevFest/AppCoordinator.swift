//
//  AppCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class AppCoordinator {
    let firebaseCoordinator = FirebaseCoordinator()
    
    let tabBarController: UITabBarController
    
    let sessionsViewController: SessionsViewController
    let starredSessionsViewController: SessionsViewController
    let speakersViewController: SpeakersViewController
    let mapViewController: MapViewController
    let settingsViewController: SettingsViewController
    
    let firebaseDateFormatter = DateFormatter()
    let sectionHeaderDateFormatter = DateFormatter()
    
    let multiSessionStarsDataSourceDelegate = MultiSessionStarsDataSourceDelegate()
    
    init(tabBarController: UITabBarController) {
        sessionsViewController = tabBarController.tabInNavigationController(atIndex: 0) as SessionsViewController
        starredSessionsViewController = tabBarController.tabInNavigationController(atIndex: 1) as SessionsViewController
        speakersViewController = tabBarController.tabInNavigationController(atIndex: 2) as SpeakersViewController
        mapViewController = tabBarController.tab(atIndex: 3) as MapViewController
        settingsViewController = tabBarController.tabInNavigationController(atIndex: 4) as SettingsViewController
        
        self.tabBarController = tabBarController
        
        firebaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        sectionHeaderDateFormatter.dateFormat = "hh:mm a"
    }
    
    func start() {
        firebaseCoordinator.start()
        
        // Make sure the AppearanceNotifier singleton has been created by now.
        _ = AppearanceNotifier.shared
        
        sessionsViewController.title = NSLocalizedString("Sessions", comment: "tab title")
        starredSessionsViewController.title = NSLocalizedString("Your Schedule", comment: "tab title")
        speakersViewController.title = NSLocalizedString("Speakers", comment: "tab title")
        mapViewController.title = NSLocalizedString("Map", comment: "tab title")
        settingsViewController.title = NSLocalizedString("Settings", comment: "tab title")
        
        let firebaseStarsDataSource = FirebaseStarsDataSource()
        firebaseStarsDataSource.sessionStarsDataSourceDelegate = multiSessionStarsDataSourceDelegate
        
        // introduce new scopes to avoid similar-sounding variables being available to cause confusion later
        do {
            let firebaseSessionsDataSource = FirebaseSessionDataSource(firebaseDateFormatter: firebaseDateFormatter, sectionHeaderDateFormatter: sectionHeaderDateFormatter)
            
            let sessionDataSource = CombinedSessionDataSource(dataSource: firebaseSessionsDataSource, starsDataSource: firebaseStarsDataSource)
            firebaseSessionsDataSource.sessionDataSourceDelegate = sessionDataSource
            multiSessionStarsDataSourceDelegate.broadcastDelegates.append(sessionDataSource)
            
            sessionsViewController.dataSource = sessionDataSource
            
            let speakerDataSource = FirebaseSpeakerDataSource()
            sessionsViewController.speakerDataSource = speakerDataSource
        }
        
        do {
            let starredSessionsFirebaseDataSource = FirebaseSessionDataSource(firebaseDateFormatter: firebaseDateFormatter, sectionHeaderDateFormatter: sectionHeaderDateFormatter)
            
            let starredSessionsDataSource = CombinedSessionDataSource(dataSource: starredSessionsFirebaseDataSource, starsDataSource: firebaseStarsDataSource)
            starredSessionsDataSource.shouldIncludeOnlyStarred = true
            multiSessionStarsDataSourceDelegate.broadcastDelegates.append(starredSessionsDataSource)
            
            starredSessionsViewController.dataSource = starredSessionsDataSource
        }
        
        do {
            let speakerDataSource = FirebaseSpeakerDataSource()
            speakerDataSource.speakerDataSourceDelegate = speakersViewController
            
            speakersViewController.speakerDataSource = speakerDataSource
        }
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
