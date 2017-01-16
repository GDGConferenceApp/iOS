//
//  SettingsCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 1/16/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

/**
 Owns a settings view controller.
 */
class SettingsCoordinator: SettingsDelegate {
    private let viewController: SettingsViewController
    
    var isSignedIn = false
    
    init(viewController: SettingsViewController) {
        self.viewController = viewController
        
        viewController.delegate = self
    }
    
    func start() {
        viewController.title = NSLocalizedString("Settings", comment: "tab title")
    }
    
    func prepareGoogleSignInViewController(_ viewController: GoogleSignInViewController) {
        viewController.isSignedIn = isSignedIn
    }
}
