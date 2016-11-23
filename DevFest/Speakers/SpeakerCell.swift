//
//  SpeakerCell.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

struct SpeakerViewModel {
    let title: String
    let subtitle: String
    let image: UIImage?
}

class SpeakerCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    var viewModel: SpeakerViewModel? {
        didSet {
            titleLabel?.text = viewModel?.title
            titleLabel?.text = viewModel?.subtitle
            
            if let image = viewModel?.image {
                imageView.image = image
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layer = imageView.layer
        layer.cornerRadius = imageView.frame.width / 2
    }
}

extension SpeakerCell: ReusableItem {
    static let reuseID: String = String(describing: SpeakerCell.self)
}
