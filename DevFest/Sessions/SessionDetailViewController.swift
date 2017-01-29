//
//  SessionDetailViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import SafariServices

/**
 Display the full details for a session.
 */
class SessionDetailViewController: UIViewController {
    @IBOutlet var sessionTitleView: SessionTitleView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var speakersStackView: UIStackView!
    @IBOutlet var speakersSectionLabel: UILabel!
    @IBOutlet var rateButton: UIButton!
    
    weak var delegate: SessionDetailViewControllerDelegate?
    
    /// Most of the session details. The `speakerIDs` are not used.
    var viewModel: SessionViewModel? {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            updateFromViewModel()
        }
    }
    
    /// The speakers to display with the session details.
    /// Used instead of `viewModel.speakerIDs`.
    var speakers: [SpeakerViewModel]? {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            updateFromViewModel()
        }
    }
    
    var imageRepository: ImageRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The speakers section label is initially in our view hierarchy thanks to the storyboard.
        // We don't want to show it by default, so remove it now.
        speakersSectionLabel.removeFromSuperview()
        
        let rateTitle = NSLocalizedString("Rate Session", comment: "Rating button on session details")
        rateButton.setTitle(rateTitle, for: .normal)
        
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
        
        descriptionTextView.font = .dev_contentFont
        speakersSectionLabel.font = .dev_sectionHeaderFont
        speakersStackView.layoutMargins = .dev_standardMargins
    }
    
    override func dev_addSessionToSchedule() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.addSessionToSchedule(for: viewModel, sender: self)
    }
    
    override func dev_removeSessionFromSchedule() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.removeSessionFromSchedule(for: viewModel, sender: self)
    }
    
    @IBAction func rate(_ sender: Any) {
        guard let id = viewModel?.sessionID else {
            return
        }
        
        let urlString = "https://devfest.mn/schedule/\(id)/feedback"
        guard let url = URL(string: urlString) else {
            NSLog("Couldn't make URL for rating session with ID: \(id)")
            return
        }
        
        let safari = SFSafariViewController(url: url)
        showDetailViewController(safari, sender: sender)
    }
    
    private func updateFromViewModel() {
        guard let viewModel = viewModel else {
            NSLog("Tried to update displayed information from view model, but no view model set.")
            return
        }
        
        sessionTitleView.viewModel = viewModel
        
        if let description = viewModel.description, !description.isEmpty {
            descriptionTextView.isHidden = false
            descriptionTextView.text = description
        } else {
            descriptionTextView.isHidden = true
        }
        
        updateSpeakersFromViewModel()
    }
    
    func updateSpeakersFromViewModel() {
        let speakerSubviews = speakersStackView.arrangedSubviews
        for speakerView in speakerSubviews {
            speakersStackView.removeArrangedSubview(speakerView)
        }
        
        guard let speakers = self.speakers, !speakers.isEmpty else {
            return
        }
        
        speakersStackView.addArrangedSubview(speakersSectionLabel)
        
        for speakerViewModel in speakers {
            let speakerView = SpeakerTitleView()
            speakerView.viewModel = speakerViewModel
            speakersStackView.addArrangedSubview(speakerView)
            
            if let url = speakerViewModel.imageURL, let imageRepository = imageRepository {
                let (image, faceRect, _) = imageRepository.image(at: url, completion: { [weak speakerView] (maybeImage, maybeFaceRect) in
                    DispatchQueue.main.async {
                        speakerView?.faceRect = maybeFaceRect
                        speakerView?.image = maybeImage ?? .speakerPlaceholder
                    }
                })
                speakerView.faceRect = faceRect
                speakerView.image = image ?? .speakerPlaceholder
            }
        }
    }

}

protocol SessionDetailViewControllerDelegate: class {
    func addSessionToSchedule(for viewModel: SessionViewModel, sender: SessionDetailViewController)
    func removeSessionFromSchedule(for viewModel: SessionViewModel, sender: SessionDetailViewController)
}
