//
//  FlowLayoutContaining.swift
//  DevFest
//
//  Created by Brendon Justin on 11/29/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

/**
 Note: The item sizes in storyboards are often set to `320`, the narrowest width
 that we expect a view controller to ever be. If it is set higher,
 when the app is run on a narrow device such as the iPhone SE,
 collection view cells start out wider than the collection view.
 This is undefined behavior and results in poor behavior on iOS 10.
 */
protocol FlowLayoutContaining {
    var flowLayout: UICollectionViewFlowLayout! { get }
    var view: UIView! { get }
    
    func updateFlowLayoutItemWidth()
}

extension FlowLayoutContaining where Self: UIViewController {
    func updateFlowLayoutItemWidth() {
        let width = view.frame.width
        flowLayout?.itemSize.width = width
    }
}
