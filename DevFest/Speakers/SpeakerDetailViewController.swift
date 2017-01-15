//
//  SpeakerDetailViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 1/15/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit
import SafariServices

/**
 Shows all of a speaker's information, that we have.
 */
class SpeakerDetailViewController: UIViewController {
    /**
     The scroll view that contains our stack view.
     */
    @IBOutlet var scrollView: UIScrollView!
    /**
     The stack view that contains all of our content subviews, except for imageView.
     */
    @IBOutlet var stackView: UIStackView!
    /**
     The stack view that contains all of our content subviews, except for imageView.
     */
    @IBOutlet var nonImageStackView: UIStackView!
    /**
     A stack view that makes its contents respect layout margins.
     */
    @IBOutlet var marginsRespectingStackView: UIStackView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var websiteButton: UIButton!
    
    /**
     The URLSession to use when fetching speakers' images.
     */
    var imageURLSession: URLSession = URLSession.shared
    
    var viewModel: SpeakerViewModel? {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            updateFromViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We have to set both `isLayoutMarginsRelativeArrangement` and the `layoutMargins`,
        // even if we want the standard `layoutMargins`, to get a stack view to respect the margins.
        marginsRespectingStackView.isLayoutMarginsRelativeArrangement = true
        
        imageView.image = UIImage(named: "speaker-placeholder")!
        updateFromViewModel()
        
        dev_updateAppearance()
        dev_registerForAppearanceUpdates()
    }
    
    override func dev_updateAppearance() {
        super.dev_updateAppearance()
        
        stackView.spacing = .dev_standardMargin
        
        nonImageStackView.spacing = .dev_standardMargin
        
        marginsRespectingStackView.layoutMargins = .dev_standardMargins
        marginsRespectingStackView.spacing = .dev_standardMargin
        
        nameLabel.font = .dev_reusableItemTitleFont
        companyLabel.font = .dev_reusableItemSubtitleFont
        bioTextView.font = .dev_contentFont
    }
    
    @IBAction func showTwitterProfile(_ sender: Any) {
        guard let twitter = viewModel?.twitter else {
            assertionFailure("Twitter button should be hidden if a speaker doesn't have a Twitter handle set.")
            return
        }
        
        let twitterURL = URL(string: "https://twitter.com/")!
        guard let url = URL(string: twitter, relativeTo: twitterURL) else {
            assertionFailure("Unexpectedly unable to construct a Twitter URL for a speaker with provided Twitter handle: \(twitter)")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        showDetailViewController(safariVC, sender: sender)
    }
    
    @IBAction func showWebsite(_ sender: Any) {
        guard let website = viewModel?.website else {
            assertionFailure("Website button should be hidden if a speaker doesn't have a website set.")
            return
        }
        
        let safariVC = SFSafariViewController(url: website)
        showDetailViewController(safariVC, sender: sender)
    }
}

private extension SpeakerDetailViewController {
    func updateFromViewModel() {
        if let image = viewModel?.image {
            imageView.image = image
        } else if let imageURL = viewModel?.imageURL {
            let task = imageURLSession.dataTask(with: imageURL) { [weak self] (data, response, error) in
                guard let data = data else {
                    return
                }
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
            
            task.resume()
        }
        
        // Assume that all speakers have a name and a bio
        nameLabel.text = viewModel?.name
        bioTextView.text = viewModel?.bio
        
        // Speakers may not have a company, twitter, or website
        if let company = viewModel?.company {
            companyLabel.isHidden = false
            companyLabel.text = company
        } else {
            companyLabel.isHidden = true
        }
        
        if let twitter = viewModel?.twitter, !twitter.isEmpty {
            twitterButton.isHidden = false
            twitterButton.setTitle("@\(twitter)", for: .normal)
        } else {
            twitterButton.isHidden = true
        }
        
        if let website = viewModel?.website, !website.absoluteString.isEmpty {
            websiteButton.isHidden = false
            websiteButton.setTitle(website.absoluteString, for: .normal)
        } else {
            websiteButton.isHidden = true
        }
    }
}
