//
//  FirebaseCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 12/21/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import Firebase

class FirebaseCoordinator: NSObject {
    func start() {
        FIRApp.configure()
    }
}
