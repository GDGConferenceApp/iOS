//
//  SpeakerCell.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SpeakerCell: UICollectionViewCell {
    @IBOutlet var speakerTitleView: SpeakerTitleView!
    
    var viewModel: SpeakerViewModel? {
        get {
            return speakerTitleView.viewModel
        }
        set {
            speakerTitleView.viewModel = newValue
        }
    }
}

extension SpeakerCell: ReusableItem {
    static let reuseID: String = String(describing: SpeakerCell.self)
}
