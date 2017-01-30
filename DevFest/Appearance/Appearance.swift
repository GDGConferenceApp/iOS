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
    /**
     The horizontal margin to use for content-y views.
     */
    static let dev_contentHorizontalMargin: CGFloat = .dev_standardMargin * 2
    
    /**
     The vertical margin to use in between content-y views.
     */
    static let dev_contentInsideVerticalMargin: CGFloat = .dev_standardMargin * 2
    
    /**
     The vertical margin to use on the outside edges of content-y views.
     */
    static let dev_contentOutsideVerticalMargin: CGFloat = .dev_standardMargin * 3
    
    /**
     The usual margin to use when space between two items is needed.
     */
    static let dev_standardMargin: CGFloat = 8
    
    /**
     A smaller margin to use for space between items.
     */
    static let dev_tightMargin: CGFloat = .dev_standardMargin / 2
    
    // Rounding is important for sizes meant to be used for views.
    static let dev_authorPhotoSideLength: CGFloat = (CGFloat.dev_standardMargin * 7).rounded()
    
    static let dev_pillButtonCornerRadius: CGFloat = (CGFloat.dev_standardMargin * 1.33).rounded()

    static let dev_shadowRadius: CGFloat = 5
    
    static var dev_trackLabelHeight: CGFloat {
        // Base the height of the track label, plus its extra margin, on the label's font size.
        let font = UIFont.dev_sessionCategoryFont
        let fontSize = font.pointSize
        return fontSize + .dev_standardMargin * 2
    }
}

extension CGSize {
    static var dev_shadowOffset: CGSize = CGSize(width: 0, height: 2)
}

extension Float {
    static var dev_shadowOpacity: Float = 0.5
}

extension UIColor {
    @nonobjc static let dev_sessionHeaderBackgroundColor: UIColor = UIColor(red: 0xf5 / 255, green: 0xf5 / 255, blue: 0xf5 / 255, alpha: 1)
    
    @nonobjc static let dev_shadowColor: UIColor = .gray

    @nonobjc static let dev_tabBarColor: UIColor = UIColor(red: 0xfa / 255, green: 0xfa / 255, blue: 0xfa / 255, alpha: 1)
    
    @nonobjc static let dev_tintColorInNavBar: UIColor = .white
    
    @nonobjc static let dev_sessionSpeakersBackgroundColor: UIColor = UIColor(red: 0xef / 255, green: 0xef / 255, blue: 0xf4 / 255, alpha: 1)
}

extension UIEdgeInsets {
    static let dev_standardMargins: UIEdgeInsets = UIEdgeInsets(top: .dev_standardMargin, left: .dev_standardMargin, bottom: .dev_standardMargin, right: .dev_standardMargin)
}

// These must be `static var`s instead of `static let`s since they can change
// if the user changes their font settings device-wide.
extension UIFont {
    
    /**
     Meant for use on body copy, i.e. longer text.
     */
    static var dev_contentFont: UIFont {
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let font = baseFont.withSize(baseFont.pointSize - 2)
        return font
    }
    
    static var dev_pillButtonTitleFont: UIFont {
        let regularFont = UIFont.preferredFont(forTextStyle: .body)
        let baseSize = regularFont.pointSize
        return UIFont.systemFont(ofSize: baseSize - 2)
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
    
    static var dev_sessionCategoryFont: UIFont {
        let baseFont = UIFont.preferredFont(forTextStyle: .footnote)
        let categoryFont = UIFont.boldSystemFont(ofSize: baseFont.pointSize)
        return categoryFont
    }
    
    static var dev_sessionLocationFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    static var dev_sessionSpeakersTitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    static var dev_sessionTitleFont: UIFont {
        return .dev_reusableItemTitleFont
    }
    
    static var dev_sessionTimeFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    static var dev_sessionTimeHeaderFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
}
