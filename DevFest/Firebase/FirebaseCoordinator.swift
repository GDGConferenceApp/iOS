//
//  FirebaseCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 12/21/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

/**
 Coordinator that sets up Firebase when `start` is called.
 */
class FirebaseCoordinator {
    /**
     The firebase database we're using.
     */
    private(set) var firebaseDatabase: FIRDatabase?
    
    private let signInDelegate = SignInDelegate()
    
    func start() {
        FIRApp.configure()
        
        firebaseDatabase = FIRDatabase.database()
        firebaseDatabase?.persistenceEnabled = true
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = signInDelegate
    }
}

private class SignInDelegate: NSObject, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Error signing in to Google: \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("Error authenticating with Firebase after signing in to Google: \(error)")
                return
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

