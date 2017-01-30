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
    
    var faceRect: CGRect? {
        get {
            return speakerTitleView.faceRect
        }
        set {
            speakerTitleView.faceRect = newValue
        }
    }
    
    var image: UIImage? {
        get {
            return speakerTitleView.image
        }
        set {
            speakerTitleView.image = newValue
        }
    }
    
    var viewModel: SpeakerViewModel? {
        get {
            return speakerTitleView.viewModel
        }
        set {
            speakerTitleView.viewModel = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dev_registerForAppearanceUpdates()
        dev_updateAppearance()
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        // Add side margins so our `speakerTitleView` is inset a bit
        contentView.layoutMargins = UIEdgeInsetsMake(0, .dev_standardMargin, 0, .dev_standardMargin)
    }
}

extension SpeakerCell: ReusableItem {
    static let reuseID: String = String(describing: SpeakerCell.self)
}
