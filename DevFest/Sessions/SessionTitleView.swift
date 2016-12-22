//
//  SessionTitleView.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

/**
 Show a session's title and other metadata.
 */
@IBDesignable
class SessionTitleView: UIView {
    private let colorView = UIView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let locationLabel = UILabel()
    private let timeLocationStackView = UIStackView()
    
    // `var` so we can make this after `init`
    private var categoryLeadingConstraint: NSLayoutConstraint?
    private var categoryTopConstraint: NSLayoutConstraint?
    private var titleTopConstraint: NSLayoutConstraint?
    private var timeLocationTopConstraint: NSLayoutConstraint?
    private var noTimeLocationTopConstraint: NSLayoutConstraint?
    private var timeLocationBottomConstraint: NSLayoutConstraint?
    
    var viewModel: SessionViewModel? {
        didSet {
            updateFromViewModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        dev_updateAppearance()
        
        viewModel = SessionViewModel(sessionID: "dummy", title: "Sample Session", description: "Sample Description", color: .green, isStarred: true, category: "android", room: "auditorium", start: nil, end: nil, speakers: [], tags: [])
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        titleLabel.font = .dev_reusableItemTitleFont
        locationLabel.font = .dev_reusableItemSubtitleFont
        categoryLabel.font = .dev_categoryFont
        
        categoryLeadingConstraint?.constant = .dev_standardMargin
        categoryTopConstraint?.constant = floor(CGFloat.dev_standardMargin / 4)
        titleTopConstraint?.constant = floor(CGFloat.dev_standardMargin / 2)
        timeLocationTopConstraint?.constant = floor(CGFloat.dev_standardMargin / 2)
        
        updateFromViewModel()
    }
    
    private func commonInit() {
        timeLocationStackView.axis = .vertical
        timeLocationStackView.addArrangedSubview(timeLabel)
        timeLocationStackView.addArrangedSubview(locationLabel)
        
        dev_addSubview(colorView)
        dev_addSubview(categoryLabel)
        dev_addSubview(titleLabel)
        dev_addSubview(timeLocationStackView)
        
        let colorViewConstraints: [NSLayoutConstraint] = [
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 12),
            ]
        
        categoryLeadingConstraint = categoryLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: .dev_standardMargin)
        categoryTopConstraint = categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: floor(CGFloat.dev_standardMargin / 4))
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: floor(CGFloat.dev_standardMargin / 2))
        timeLocationTopConstraint = timeLocationStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: floor(CGFloat.dev_standardMargin / 2))
        timeLocationBottomConstraint = timeLocationStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        
        let otherLeftConstraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            timeLocationStackView.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
        ]

        // not activated by default
        noTimeLocationTopConstraint = timeLocationStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        
        // activate all constraints except `noTimeLocationTopConstraint`
        NSLayoutConstraint.activate(colorViewConstraints)
        categoryLeadingConstraint?.isActive = true
        categoryTopConstraint?.isActive = true
        titleTopConstraint?.isActive = true
        timeLocationTopConstraint?.isActive = true
        timeLocationBottomConstraint?.isActive = true
        NSLayoutConstraint.activate(otherLeftConstraints)
        
        dev_updateAppearance()
    }
    
    private func updateFromViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        let categoryColor = viewModel.color
        colorView.backgroundColor = categoryColor
        categoryLabel.textColor = categoryColor
        
        categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
        if let duration = viewModel.durationString(using: .dev_startAndEndFormatter) {
            timeLabel.text = duration
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
        
        if let location = viewModel.room {
            locationLabel.text = location
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        
        let noTimeOrLocation = timeLabel.isHidden && locationLabel.isHidden
        timeLocationTopConstraint?.isActive = !noTimeOrLocation
        noTimeLocationTopConstraint?.isActive = noTimeOrLocation
    }
}
