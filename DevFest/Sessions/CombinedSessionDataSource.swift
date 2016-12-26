//
//  CombinedSessionDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/26/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import Foundation

/**
 A pass-through Session data source that persists Session starred status.
 
 It is recommended that instances of this class be the `sessionDataSourceDelegate`s
 of their `dataSource` property.
 */
class CombinedSessionDataSource: SessionDataSource, SessionStarsDataSource {
    /// The data source that we will get our sessions from.
    let dataSource: SessionDataSource
    /// The data source that we will get our session starred statuses from.
    let starsDataSource: SessionStarsDataSource
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    weak var sessionStarsDataSourceDelegate: SessionStarsDataSourceDelegate?
    
    var shouldIncludeOnlyStarred: Bool {
        return dataSource.shouldIncludeOnlyStarred
    }
    
    var numberOfSections: Int {
        return dataSource.numberOfSections
    }
    
    init(dataSource: SessionDataSource, starsDataSource: SessionStarsDataSource) {
        self.dataSource = dataSource
        self.starsDataSource = starsDataSource
    }
    
    // MARK: - SessionDataSource
    
    func viewModel(at indexPath: IndexPath) -> SessionViewModel {
        var vm = dataSource.viewModel(at: indexPath)
        vm.isStarred = isStarred(viewModel: vm)
        return vm
    }
    
    func indexPathOfSession(withSessionID sessionID: String) -> IndexPath? {
        return dataSource.indexPathOfSession(withSessionID: sessionID)
    }
    
    // MARK: - DataSource
    
    func numberOfItems(inSection section: Int) -> Int {
        return dataSource.numberOfItems(inSection: section)
    }
    
    func title(forSection section: Int) -> String? {
        return dataSource.title(forSection: section)
    }
    
    // MARK: - SessionStarsDataSource
    
    func isStarred(viewModel: SessionViewModel) -> Bool {
        // Ignore the `viewModel`s `isStarred`, checking our data store instead.
        return starsDataSource.isStarred(viewModel: viewModel)
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        return starsDataSource.starSession(for: viewModel)
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        return starsDataSource.unstarSession(for: viewModel)
    }
}

extension CombinedSessionDataSource: SessionDataSourceDelegate, SessionStarsDataSourceDelegate {
    func sessionDataSourceDidUpdate() {
        // do something here?
        sessionDataSourceDelegate?.sessionDataSourceDidUpdate()
    }
    
    func sessionStarsDidUpdate() {
        // do something here too?
        sessionStarsDataSourceDelegate?.sessionStarsDidUpdate()
    }
}
