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
    
    var dataSource: SessionDataSource? {
        didSet {
            dataSource?.shouldIncludeOnlyStarred = shouldShowStarredOnly
        }
    }
    
    var shouldShowStarredOnly = false {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            dataSource?.shouldIncludeOnlyStarred = shouldShowStarredOnly
            
            collectionView?.reloadData()
        }
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
        let viewModel = dataSource!.viewModel(atIndex: indexPath.item)
        return viewModel
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = dataSource?.numberOfItems(inSection: section) ?? 0
        return numberOfItems
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
        guard let dataSource = dataSource, let sessionIndex = dataSource.indexOfSession(withSessionID: identifier) else {
            return
        }

        let existingViewModel = dataSource.viewModel(atIndex: sessionIndex)
        let updatedViewModel: SessionViewModel
        if existingViewModel.isStarred {
            updatedViewModel = dataSource.unstarSession(for: existingViewModel)
        } else {
            updatedViewModel = dataSource.starSession(for: existingViewModel)
        }
        
        let indexPath = IndexPath(item: sessionIndex, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? SessionCell {
            cell.viewModel = updatedViewModel
        }
    }
}
