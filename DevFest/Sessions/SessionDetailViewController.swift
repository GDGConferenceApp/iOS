//
//  SessionDetailViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {
    @IBOutlet var sessionTitleView: SessionTitleView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var speakersStackView: UIStackView!
    
    @IBOutlet var speakersSectionLabel: UILabel!
    
    var viewModel: SessionViewModel? {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            updateFromViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromViewModel()
        
        // We have to set both `isLayoutMarginsRelativeArrangement` and the `layoutMargins`,
        // even if we want the standard `layoutMargins`, to get a stack view to respect the margins.
        speakersStackView.isLayoutMarginsRelativeArrangement = true
        
        dev_updateAppearance()
        dev_registerForAppearanceUpdates()
        
        speakersSectionLabel.text = NSLocalizedString("Speakers:", comment: "Speakers section delineator in the session detail view")
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        speakersSectionLabel.font = .dev_sectionHeaderFont
        speakersStackView.layoutMargins = .dev_standardMargins
    }
    
    private func updateFromViewModel() {
        guard let viewModel = viewModel else {
            NSLog("Tried to update displayed information from view model, but no view model set.")
            return
        }
        
        sessionTitleView.viewModel = viewModel
        
        descriptionTextView.text = "Placeholder bio."
        
        let speakerSubviews = speakersStackView.arrangedSubviews
        for speakerView in speakerSubviews {
            speakersStackView.removeArrangedSubview(speakerView)
        }
        
        guard case let speakers = viewModel.speakers, !speakers.isEmpty else {
            return
        }
        
        speakersStackView.addArrangedSubview(speakersSectionLabel)
        
        for speaker in viewModel.speakers {
            let speakerView = SpeakerTitleView()
            speakerView.viewModel = speaker
            speakersStackView.addArrangedSubview(speakerView)
        }
    }

}
