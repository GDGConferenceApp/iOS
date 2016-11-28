//
//  UIFont+DevFest.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

// These must be `static var`s instead of `static let`s since they can change
// if the user changes their font settings device-wide.
extension UIFont {
    static var dev_reusableItemTitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    static var dev_reusableItemSubtitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static var dev_categoryFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
}
