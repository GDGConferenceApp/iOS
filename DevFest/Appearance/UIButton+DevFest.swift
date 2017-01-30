//
//  UIButton+DevFest.swift
//  DevFest
//
//  Created by Brendon Justin on 1/30/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

extension UIButton {
    /**
     Vertically align our image view and title label, using `contentEdgeInsets`, `imageEdgeInsets`, and `titleEdgeInsets`.
     
     Based on http://stackoverflow.com/a/22621613/1610271
     
     - note: This method is not safe to use in the same runloop that our `title` and/or `image` is changed in,
     as it will then use the old values when doing its calculations instead of the new values.
     */
    func updateInsetsForVerticalImageAndTitle(innerPadding: CGFloat = .dev_tightMargin) {
        guard let imageView = imageView, let titleLabel = titleLabel else {
            return
        }
        
        // Layout (if needed) so our imageView and titleLabel have their final sizes already.
        layoutIfNeeded()
        
        let imageSize = imageView.frame.size
        let titleSize = titleLabel.frame.size
        
        let largerHeight = max(imageSize.height, titleSize.height)
        let totalHeight = imageSize.height + titleSize.height + innerPadding
        
        imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0, 0, -titleSize.width)
        titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0)
        contentEdgeInsets = UIEdgeInsetsMake((totalHeight - largerHeight) / 2, 0, (totalHeight - largerHeight) / 2, 0)
    }
}
