//
//  SessionCell.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

/**
 Display data from a `SessionViewModel`. Star toggle events are passed up the responder chain
 using `UIResponder.dev_toggleStarred(forSessionID:)`.
 */
class SessionCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var starButton: UIButton!
    
    var viewModel: SessionViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            subtitleLabel.text = viewModel?.room
            
            if let track = viewModel?.track {
                trackLabel.text = track
                trackLabel.isHidden = false
            } else {
                trackLabel.isHidden = true
            }
            
            trackLabel.textColor = viewModel?.color ?? .black
            colorView.backgroundColor = viewModel?.color
            
            let image: UIImage
            if viewModel?.isStarred ?? false {
                image = #imageLiteral(resourceName: "star-filled-icons8")
            } else {
                image = #imageLiteral(resourceName: "star-icons8")
            }
            starButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func toggleStarred(sender: AnyObject?) {
        guard let identifier = viewModel?.sessionID else {
            NSLog("Tried to toggle session starred state without a view model.")
            return
        }
        
        dev_toggleStarred(forSessionID: identifier)
    }
}

extension SessionCell: ReusableItem {
    static let reuseID: String = String(describing: SessionCell.self)
}

extension UIResponder {
    func dev_toggleStarred(forSessionID identifier: String) {
        next?.dev_toggleStarred(forSessionID: identifier)
    }
}
