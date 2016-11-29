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
    
    /**
     Constrain `self` to its `superview`'s margins.
     */
    @discardableResult
    func dev_constrainToSuperMargins(shouldActivate: Bool = true) -> [NSLayoutConstraint] {
        guard let containing = superview else {
            assertionFailure("Must have a superview to constrain our edges to it.")
            return []
        }
        
        let superConstraints: [NSLayoutConstraint] = [
            leadingAnchor.constraint(equalTo: containing.layoutMarginsGuide.leadingAnchor),
            topAnchor.constraint(equalTo: containing.layoutMarginsGuide.topAnchor),
            trailingAnchor.constraint(equalTo: containing.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: containing.layoutMarginsGuide.bottomAnchor),
        ]
        
        for constraint in superConstraints {
            constraint.identifier = "dev_constrainToSuperMargins constraint"
        }
        
        if shouldActivate {
            NSLayoutConstraint.activate(superConstraints)
        }
        
        return superConstraints
    }
}
