//
//  SessionHeaderCollectionReusableView.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SessionHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet private var timeLabel: UILabel!
}

extension SessionHeaderCollectionReusableView: ReusableItem {
    static let reuseID: String = String(describing: SessionHeaderCollectionReusableView.self)
}
