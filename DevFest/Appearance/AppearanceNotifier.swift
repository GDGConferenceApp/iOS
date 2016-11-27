//
//  AppearanceNotifier.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let DEVAppearanceDidChange: Notification.Name = Notification.Name(rawValue: "DEVAppearanceDidChange")
}

/**
 Posts `Notification.Name.DEVAppearanceDidChange` notifications when any colors, fonts, etc, are changed.
 
 Access the `shared` static member to create an instance for the app.
 */
final class AppearanceNotifier: NSObject {
    static let shared = AppearanceNotifier()
    private let observerToken: AnyObject
    
    private override init() {
        observerToken = NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: nil, queue: nil) { _ in
            NotificationCenter.default.post(name: .DEVAppearanceDidChange, object: nil)
        }
        
        super.init()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observerToken)
    }
}