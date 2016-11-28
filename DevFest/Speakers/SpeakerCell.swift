//
//  SpeakerCell.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SpeakerCell: UICollectionViewCell {
    @IBOutlet var speakerCellView: SpeakerCellView!
    
    var viewModel: SpeakerViewModel? {
        get {
            return speakerCellView.viewModel
        }
        set {
            speakerCellView.viewModel = newValue
        }
    }
}

extension SpeakerCell: ReusableItem {
    static let reuseID: String = String(describing: SpeakerCell.self)
}

@IBDesignable
class SpeakerCellView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private lazy var titleSubtitleStackView: UIStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel,])
    private lazy var horizontalStackView: UIStackView = UIStackView(arrangedSubviews: [self.imageView, self.titleSubtitleStackView,])
    
    private var addedConstraints: [NSLayoutConstraint] = []
    
    @IBInspectable var titleSubtitleSpacing: CGFloat = 4 {
        didSet {
            updateSpacing()
        }
    }
    @IBInspectable var imageTitleSpacing: CGFloat = 4 {
        didSet {
            updateSpacing()
        }
    }
    
    var viewModel: SpeakerViewModel? {
        didSet {
            titleLabel.text = viewModel?.name
            subtitleLabel.text = viewModel?.association
            
            if let image = viewModel?.image {
                imageView.image = image
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Include `init(frame:)` so we work via IBDesignable, but keep `subviewsInit` in
        // `prepareForInterfaceBuilder` since IB doesn't like some of that logic in an `init`.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subviewsInit()
        
        // only run this once, in `init`.
        dev_registerForAppearanceUpdates()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layer = imageView.layer
        layer.cornerRadius = imageView.frame.width / 2
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        viewModel = SpeakerViewModel(speakerID: "dummy", name: "Speaker Name", association: "Organization, LLC", imageURL: nil, image: nil, twitter: nil, website: nil)
        subviewsInit()
    }
    
    private func subviewsInit() {
        titleSubtitleStackView.axis = .vertical

        updateSpacing()
        dev_addSubview(horizontalStackView)
        
        removeConstraints(addedConstraints)
        addedConstraints = [
            // Constrain to our margins
            horizontalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            ]
        
        NSLayoutConstraint.activate(addedConstraints)
        
        dev_updateAppearance()
    }
    
    private func updateSpacing() {
        layoutMargins.left = .dev_standardMargin * 1.5
        titleSubtitleStackView.spacing = titleSubtitleSpacing
        horizontalStackView.spacing = imageTitleSpacing
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        titleLabel.font = .dev_reusableItemTitleFont
        subtitleLabel.font = .dev_reusableItemSubtitleFont
    }
}
