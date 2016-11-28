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
    
    struct Fixture {
        static let speakers: [SpeakerViewModel] = [
            SpeakerViewModel(speakerID: "eins", name: "Spongebob Squarepants", association: "Krusty Krab", imageURL: nil, image: nil, twitter: nil, website: nil),
            SpeakerViewModel(speakerID: "swei", name: "Patrick Star", association: "n/a", imageURL: nil, image: nil, twitter: nil, website: nil),
            SpeakerViewModel(speakerID: "drei", name: "Squidward Tentacles", association: "Krusty Krab", imageURL: nil, image: nil, twitter: nil, website: nil),
            ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayoutItemWidth()
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Fixture.speakers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as SpeakerCell
        let item = Fixture.speakers[indexPath.item]
        cell.viewModel = item
        return cell
    }

}
