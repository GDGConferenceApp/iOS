//
//  UIColor+DevFest.swift
//  DevFest
//
//  Created by Brendon Justin on 1/28/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Create a 1x1 size image of `self` color.
     */
    func dev_asImage() -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(self.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
