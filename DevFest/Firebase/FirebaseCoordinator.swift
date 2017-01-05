//
//  FirebaseCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 12/21/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/**
 Coordinator that sets up Firebase when `start` is called.
 */
class FirebaseCoordinator {
    /**
     The firebase database we're using.
     */
    private(set) var firebaseDatabase: FIRDatabase?
    
    func start() {
        FIRApp.configure()
        
        firebaseDatabase = FIRDatabase.database()
        firebaseDatabase?.persistenceEnabled = true
    }
}
