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
    
    private var mapFileURL: URL? {
        didSet {
            viewController.mapFileURL = mapFileURL
        }
    }
    
    init(viewController: SettingsViewController) {
        self.viewController = viewController
        
        let bundle = Bundle.main
        mapFileURL = bundle.url(forResource: "schultze-hall-map", withExtension: "pdf")!
        
        viewController.delegate = self
    }
    
    func start() {
        viewController.title = NSLocalizedString("Info", comment: "tab title")
        viewController.mapFileURL = mapFileURL
    }
    
    func prepareGoogleSignInViewController(_ viewController: GoogleSignInViewController) {
        viewController.isSignedIn = isSignedIn
    }
}
