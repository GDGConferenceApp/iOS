//
//  SpeakerDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 1/2/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

protocol SpeakerDataSource: DataSource {
    var speakerDataSourceDelegate: SpeakerDataSourceDelegate? { get set }
    
    func viewModel(at indexPath: IndexPath) -> SpeakerViewModel
    func indexPathOfSpeaker(withSpeakerID speakerID: String) -> IndexPath?
}

protocol SpeakerDataSourceDelegate: class {
    func speakerDataSourceDidUpdate()
}

final class SpeakerFixture: SpeakerDataSource {
    static let speakers: [SpeakerViewModel] = [
        SpeakerViewModel(speakerID: "eins", name: "Spongebob Squarepants", association: "Krusty Krab", imageURL: nil, image: #imageLiteral(resourceName: "podium-icons8"), twitter: nil, website: nil),
        SpeakerViewModel(speakerID: "swei", name: "Patrick Star", association: "n/a", imageURL: nil, image: nil, twitter: nil, website: nil),
        SpeakerViewModel(speakerID: "drei", name: "Squidward Tentacles", association: "Krusty Krab", imageURL: nil, image: nil, twitter: nil, website: nil),
        ]
    
    let numberOfSections: Int = 1
    
    weak var speakerDataSourceDelegate: SpeakerDataSourceDelegate?
    
    func numberOfItems(inSection section: Int) -> Int {
        return SpeakerFixture.speakers.count
    }
    
    func title(forSection section: Int) -> String? {
        return nil
    }

    func viewModel(at indexPath: IndexPath) -> SpeakerViewModel {
        return SpeakerFixture.speakers[indexPath.item]
    }
    
    func indexPathOfSpeaker(withSpeakerID speakerID: String) -> IndexPath? {
        let maybeIdx = SpeakerFixture.speakers.index(where: { vm in vm.speakerID == speakerID })
        let maybeIndexPath = maybeIdx.map { IndexPath(item: $0, section: 0) }
        return maybeIndexPath
    }
}
