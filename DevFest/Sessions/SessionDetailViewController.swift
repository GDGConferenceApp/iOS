//
//  SessionDetailViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/27/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SessionDetailViewController: UICollectionViewController {
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
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        // Use a separate variable since we can't declare variables that subclass a class plus implement a protocol
        let vmConsumer: SessionViewModelConsumer?
        
        switch CellType(at: indexPath) {
        case .title:
            let title = collectionView.dequeueCell(for: indexPath) as SessionTitleCell
            vmConsumer = title
            cell = title
        case .description:
            let description = collectionView.dequeueCell(for: indexPath) as SessionDescriptionCell
            vmConsumer = description
            cell = description
        case let .speaker(index: speakerIndex):
            let speaker = collectionView.dequeueCell(for: indexPath) as SessionSpeakerCell
            let speakerViewModel = viewModel?.speakers[speakerIndex]
            speaker.viewModel = speakerViewModel
            vmConsumer = nil
            cell = speaker
        }
        
        vmConsumer?.viewModel = viewModel
        
        return cell
    }
    
    private func updateFromViewModel() {
        guard let _ = viewModel, let collectionView = collectionView else {
            NSLog("Tried to update displayed information from view model, but either no view model or no collection view.")
            return
        }
        
        // TODO: Fine-grained updates
        collectionView.reloadData()
    }

}

private enum CellType {
    case title
    case description
    case speaker(index: Int)
    
    init(at indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self = .title
        case 1:
            self = .description
        case let value where value > 0:
            self = .speaker(index: value - 2)
        default:
            fatalError()
        }
    }
}

protocol SessionViewModelConsumer {
    var viewModel: SessionViewModel? { get set }
}

private class SessionDescriptionCell: UICollectionViewCell, ReusableItem, SessionViewModelConsumer {
    static let reuseID = String(describing: SessionDescriptionCell.self)
    
    var viewModel: SessionViewModel?
}

private class SessionSpeakerCell: UICollectionViewCell, ReusableItem {
    static let reuseID = String(describing: SessionSpeakerCell.self)
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var speakerCellView: SpeakerCellView!
    
    var viewModel: SpeakerViewModel? {
        didSet {
            speakerCellView.viewModel = viewModel
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("Speaker:", comment: "")
    }
}
