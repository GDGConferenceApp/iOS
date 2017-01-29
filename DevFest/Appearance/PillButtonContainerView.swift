//
//  PillButtonContainerView.swift
//  DevFest
//
//  Created by Brendon Justin on 1/28/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

/**
 A view that contains a button and gives that button a pill-like appearance.
 */
@IBDesignable
class PillButtonContainerView: UIView {
    private static let minimumWidth: CGFloat = 100
    @IBOutlet var button: UIButton!
    
    override var intrinsicContentSize: CGSize {
        guard let buttonSize = button?.intrinsicContentSize else {
            return CGSize(width: 10, height: PillButtonContainerView.minimumWidth)
        }
        
        var minWidthButtonSize = buttonSize
        if minWidthButtonSize.width < PillButtonContainerView.minimumWidth {
            minWidthButtonSize.width = PillButtonContainerView.minimumWidth
        }
        
        return minWidthButtonSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dev_registerForAppearanceUpdates()
        dev_updateAppearance()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        dev_updateAppearance()
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        button.titleLabel?.font = .dev_pillButtonTitleFont
        
        let verticalMargin = CGFloat.dev_standardMargin
        let horizontalMargin = CGFloat.dev_standardMargin * 2
        button.contentEdgeInsets = UIEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin)
        if let _ = button.image(for: .normal) {
            let buttonHorizontalMargin = CGFloat.dev_standardMargin / 2
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -buttonHorizontalMargin, 0, buttonHorizontalMargin)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, buttonHorizontalMargin, 0, -buttonHorizontalMargin)
        } else {
            button.imageEdgeInsets = .zero
            button.titleEdgeInsets = .zero
        }
        
        // It's convenient to have `tintColor` in a local variable so we can see it in the debugger more easily.
        let tintColor = self.tintColor
        button.backgroundColor = tintColor
        
        button.tintColor = .white
        
        let layer = button.layer
        layer.cornerRadius = .dev_pillButtonCornerRadius
        layer.masksToBounds = true
    }
}
