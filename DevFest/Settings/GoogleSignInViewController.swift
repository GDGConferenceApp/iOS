//
//  GoogleSignInViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 1/14/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

import GoogleSignIn

class GoogleSignInViewController: UIViewController, GIDSignInUIDelegate {
    // The top constraint of our top-most subview
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet var signOutButton: UIButton!
    
    var shouldAutoSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Sign In", comment: "Google sign in view controller title")
        
        signOutButton.isEnabled = false
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        dev_updateAppearance()
        dev_registerForAppearanceUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAutoSignIn {
            shouldAutoSignIn = false
            // Signing in silently doesn't work from viewDidLoad, so try in viewDidAppear.
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        topConstraint.constant = .dev_standardMargin
    }
}
