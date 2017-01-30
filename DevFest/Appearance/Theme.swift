//
//  Theme.swift
//  DevFest
//
//  Created by Brendon Justin on 1/29/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

struct Theme {
    /// Setup default appearances via appearance proxies
    static func setupAppearanceProxies() {
        
        let navAppearance = UINavigationBar.appearance()
        // Set our bar colors
        navAppearance.tintColor = .dev_tintColorInNavBar
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dev_tintColorInNavBar]
        
        let tabAppearance = UITabBar.appearance()
        tabAppearance.barTintColor = .dev_tabBarColor
        tabAppearance.isTranslucent = false
    }
}
