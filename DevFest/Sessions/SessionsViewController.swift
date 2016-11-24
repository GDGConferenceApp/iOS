//
//  SessionsViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SessionsViewController: UICollectionViewController {
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    
    var shouldShowStarredOnly = false {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            collectionView?.reloadData()
        }
    }
    
    final class Fixture {
        static var items: [SessionViewModel] = [
            SessionViewModel(sessionID: "one", title: "First Session", color: .green, isStarred: false, category: "android", room: "auditorium", start: nil, end: nil, speakers: [], tags: []),
            SessionViewModel(sessionID: "two", title: "Session Two", color: .blue, isStarred: true, category: "design", room: "classroom 1", start: nil, end: nil, speakers: [], tags: []),
            SessionViewModel(sessionID: "three", title: "Session the Third", color: .black, isStarred: false, category: nil, room: "lab", start: nil, end: nil, speakers: [], tags: []),
        ]
        
        static let starredItems: [SessionViewModel] = items.filter { $0.isStarred }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.width
        
        // Note: The item size in the storyboard is set to `320`, the narrowest width
        // that we expect this view controller to ever be. If it is set higher,
        // when the app is run on a narrow device such as the iPhone SE,
        // our collection view cells start wider than the collection view.
        // This is undefined behavior and results in poor behavior on iOS 10.
        flowLayout.estimatedItemSize = CGSize(width: width, height: 100)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = shouldShowStarredOnly ? Fixture.starredItems : Fixture.items
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let items = shouldShowStarredOnly ? Fixture.starredItems : Fixture.items
        
        let cell = collectionView.dequeueCell(for: indexPath) as SessionCell
        cell.viewModel = items[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueSupplementaryView(ofKind: kind, for: indexPath) as SessionHeaderCollectionReusableView
        return view
    }
    
    // MARK: UIResponder
    
    override func dev_toggleStarred(forSessionID identifier: String) {
        guard let sessionIndex = Fixture.items.index(where: { return $0.sessionID == identifier }) else {
            return
        }

        let indexPath = IndexPath(item: sessionIndex, section: 0)
        var updatedViewModel = Fixture.items[sessionIndex]
        updatedViewModel.isStarred = !updatedViewModel.isStarred
        if let cell = collectionView?.cellForItem(at: indexPath) as? SessionCell {
            cell.viewModel?.isStarred = updatedViewModel.isStarred
        }
        
        Fixture.items[sessionIndex] = updatedViewModel
    }
}
