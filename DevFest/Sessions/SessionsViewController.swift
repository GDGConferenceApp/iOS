//
//  SessionsViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

class SessionsViewController: UICollectionViewController, FlowLayoutContaining {
    @IBInspectable private var detailSegueIdentifier: String = "sessionDetail"
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
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
            SessionViewModel(sessionID: "one", title: "First Session", color: .green, isStarred: false, category: "android", room: "auditorium", start: nil, end: nil, speakers: [Fixture.speakers[0]], tags: []),
            SessionViewModel(sessionID: "two", title: "Session Two", color: .blue, isStarred: true, category: "design", room: "classroom 1", start: nil, end: nil, speakers: [], tags: []),
            SessionViewModel(sessionID: "three", title: "Session the Third", color: .black, isStarred: false, category: nil, room: "lab", start: nil, end: nil, speakers: [], tags: []),
        ]
        
        static var speakers: [SpeakerViewModel] { return SpeakersViewController.Fixture.speakers }
        
        static let starredItems: [SessionViewModel] = items.filter { $0.isStarred }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayoutItemWidth()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayoutOnTransition(toViewSize: size, with: coordinator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, sender, segue.destination) {
        case (detailSegueIdentifier?, let cell as SessionCell, let destination as SessionDetailViewController):
            let indexPath = collectionView?.indexPath(for: cell)
            let viewModel = indexPath.map { return self.viewModel(at: $0) }
            destination.viewModel = viewModel
        default:
            break
        }
    }
    
    private func viewModel(at indexPath: IndexPath) -> SessionViewModel {
        let items = shouldShowStarredOnly ? Fixture.starredItems : Fixture.items
        let viewModel = items[indexPath.item]
        return viewModel
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = shouldShowStarredOnly ? Fixture.starredItems : Fixture.items
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as SessionCell
        cell.viewModel = viewModel(at: indexPath)
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
