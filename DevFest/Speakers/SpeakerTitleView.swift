//
//  SpeakerTitleView.swift
//  DevFest
//
//  Created by Brendon Justin on 11/29/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

@IBDesignable
class SpeakerTitleView: UIView {
    fileprivate let titleLabel = UILabel()
    fileprivate let subtitleLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate lazy var titleSubtitleStackView: UIStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel,])
    fileprivate lazy var horizontalStackView: UIStackView = UIStackView(arrangedSubviews: [self.imageView, self.titleSubtitleStackView,])
    
    fileprivate var imageViewWidthConstraint: NSLayoutConstraint?
    
    /**
     Constraints between subviews and `self`. Track these so we only add them once when
     this class is used in interface builder.
     */
    fileprivate var addedConstraints: [NSLayoutConstraint] = []
    
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
            
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let maxSize = CGSize(width: .max, height: .max)
        let horizontalStackViewSize = horizontalStackView.systemLayoutSizeFitting(maxSize)
        
        let width = horizontalStackViewSize.width + layoutMargins.left + layoutMargins.right
        let height = horizontalStackViewSize.height + layoutMargins.top + layoutMargins.bottom
        
        return CGSize(width: width, height: height)
    }
    
    init() {
        super.init(frame: .zero)
        subviewsInit()
        
        dev_registerForAppearanceUpdates()
    }
    
    /**
     Only present for IB. Use `init()` instead.
     */
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
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        titleLabel.font = .dev_reusableItemTitleFont
        subtitleLabel.font = .dev_reusableItemSubtitleFont
        
        imageViewWidthConstraint?.constant = .dev_authorPhotoSideLength
    }
}

fileprivate extension SpeakerTitleView {
    func subviewsInit() {
        titleSubtitleStackView.axis = .vertical
        horizontalStackView.alignment = .top
        
        updateSpacing()
        dev_addSubview(horizontalStackView)
        
        removeConstraints(addedConstraints)
        
        let imageViewWidth = imageView.widthAnchor.constraint(equalToConstant: .dev_authorPhotoSideLength)
        imageViewWidthConstraint = imageViewWidth
        imageViewWidth.priority = UILayoutPriorityRequired - 1
        let imageConstraints: [NSLayoutConstraint] = [
            // Make the image view fixed-size and square
            imageViewWidth,
            imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            ]
        
        let stackConstraints = horizontalStackView.dev_constrainToSuperMargins(shouldActivate: false)
        
        addedConstraints.append(contentsOf: imageConstraints)
        addedConstraints.append(contentsOf: stackConstraints)
        
        NSLayoutConstraint.activate(addedConstraints)
        
        dev_updateAppearance()
    }
    
    func updateSpacing() {
        layoutMargins.left = .dev_standardMargin * 1.5
        titleSubtitleStackView.spacing = titleSubtitleSpacing
        horizontalStackView.spacing = imageTitleSpacing
        
        invalidateIntrinsicContentSize()
    }
}
