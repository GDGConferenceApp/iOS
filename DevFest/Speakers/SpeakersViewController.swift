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

}

extension SpeakersViewController: SpeakerDataSourceDelegate {
    func speakerDataSourceDidUpdate() {
        collectionView?.reloadData()
    }
}
