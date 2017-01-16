//
//  SpeakersCollectionViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SpeakersViewController: UICollectionViewController, FlowLayoutContaining {
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    var speakerDataSource: SpeakerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayoutItemWidth()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayoutOnTransition(toViewSize: size, with: coordinator)
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speakerDataSource?.numberOfItems(inSection: section) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as SpeakerCell
        let viewModel = speakerDataSource!.viewModel(at: indexPath)
        cell.viewModel = viewModel
        return cell
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.destination, sender) {
        case (let detailVC as SpeakerDetailViewController, let cell as SpeakerCell):
            guard let viewModel = cell.viewModel else {
                assertionFailure("No view model found on cell that triggered a detail segue. Was the cell set up correctly?")
                return
            }
            
            detailVC.viewModel = viewModel
            break
        default:
            NSLog("Unexpected segue: \(segue)")
            break
        }
    }
}

extension SpeakersViewController: SpeakerDataSourceDelegate {
    func speakerDataSourceDidUpdate() {
        collectionView?.reloadData()
    }
}
