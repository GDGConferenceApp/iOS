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
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Sign In", comment: "Google sign in view controller title")
        
        signOutButton.isEnabled = false
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // Signing in silently seems to just push a white view with no way to exit, so don't try.
        // GIDSignIn.sharedInstance().signIn()
    }
}
