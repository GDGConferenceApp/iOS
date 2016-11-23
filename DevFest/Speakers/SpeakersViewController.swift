//
//  SpeakersCollectionViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SpeakersViewController: UICollectionViewController {
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Note: The item size in the storyboard is set to `320`, the narrowest width
        // that we expect this view controller to ever be. If it is set higher,
        // when the app is run on a narrow device such as the iPhone SE,
        // our collection view cells start wider than the collection view.
        // This is undefined behavior and results in poor behavior on iOS 10.
        flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as SpeakerCell
        return cell
    }

}
