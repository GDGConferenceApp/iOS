//
//  CGFloat+DevFest.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import CoreGraphics
import UIKit

// All things layout margins

extension CGFloat {
    static var dev_standardMargin: CGFloat = 8
    
    static var dev_authorPhotoSideLength: CGFloat {
        return .dev_standardMargin * 5
    }
}

extension UIEdgeInsets {
    static var dev_standardMargins: UIEdgeInsets {
        return UIEdgeInsets(top: .dev_standardMargin, left: .dev_standardMargin, bottom: .dev_standardMargin, right: .dev_standardMargin)
    }
}

// These must be `static var`s instead of `static let`s since they can change
// if the user changes their font settings device-wide.
extension UIFont {
    static var dev_categoryFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    static var dev_reusableItemTitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    static var dev_reusableItemSubtitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static var dev_sectionHeaderFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .title3)
    }
}
