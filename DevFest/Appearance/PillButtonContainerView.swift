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
    @IBOutlet var button: UIButton!
    
    override var intrinsicContentSize: CGSize {
        guard let buttonSize = button?.intrinsicContentSize else {
            return CGSize(width: 10, height: 10)
        }
        
        let verticalMargin = CGFloat.dev_standardMargin
        let horizontalMargin = CGFloat.dev_standardMargin * 2
        var size = buttonSize
        size.height += verticalMargin * 2
        size.width += horizontalMargin * 2
        return size
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
        
        let verticalMargin = CGFloat.dev_standardMargin
        let horizontalMargin = CGFloat.dev_standardMargin * 2
        button.contentEdgeInsets = UIEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin)
        
        // It's convenient to have `tintColor` in a local variable so we can see it in the debugger more easily.
        let tintColor = self.tintColor
        button.backgroundColor = tintColor
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        
        let layer = button.layer
        layer.cornerRadius = .dev_standardMargin
        layer.masksToBounds = true
    }
}
