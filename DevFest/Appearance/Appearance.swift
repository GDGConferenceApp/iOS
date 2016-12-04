//
//  Appearance.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import CoreGraphics
import UIKit

// All things appearance, e.g. colors, margins, sizes

extension CGFloat {
    static var dev_standardMargin: CGFloat = 8
    
    static var dev_authorPhotoSideLength: CGFloat {
        return .dev_standardMargin * 5
    }
    
    static var dev_shadowRadius: CGFloat = 5
}

extension CGSize {
    static var dev_shadowOffset: CGSize = .zero
}

extension Float {
    static var dev_shadowOpacity: Float = 0.5
}

extension UIColor {
    static var dev_shadowColor: UIColor {
        return .gray
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
