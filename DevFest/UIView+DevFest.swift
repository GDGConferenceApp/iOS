//
//  UIView+DevFest.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Add `view` and set its `translatesAutoResizingMaskIntoConstraints` at the same time.
     `translatesAutoResizingMaskIntoConstraints` is `false` by default.
     */
    func dev_addSubview(_ view: UIView, translatesAutoresizingMaskIntoConstraints: Bool = false) {
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        addSubview(view)
    }
}
