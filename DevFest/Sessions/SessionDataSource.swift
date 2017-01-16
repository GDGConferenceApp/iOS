//
//  SessionDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/22/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import Foundation

protocol SessionDataSource: DataSource {
    var sessionDataSourceDelegate: SessionDataSourceDelegate? { get set }
    
    func viewModel(at indexPath: IndexPath) -> SessionViewModel
    func indexPathOfSession(withSessionID sessionID: String) -> IndexPath?
}

protocol SessionDataSourceDelegate: class {
    func sessionDataSourceDidUpdate()
}

final class SessionFixture: SessionDataSource, SessionStarsDataSource {
    static var items: [SessionViewModel] = [
        SessionViewModel(sessionID: "one", title: "First Session", description: "First Session Description", isStarred: false, track: "android", room: "auditorium", start: nil, end: nil, speakerIDs: [speakers[0].speakerID], tags: []),
        SessionViewModel(sessionID: "two", title: "Session Two", description: "Session Two Description", isStarred: true, track: "design", room: "classroom 1", start: nil, end: nil, speakerIDs: [], tags: []),
        SessionViewModel(sessionID: "three", title: "Session the Third", description: "Session the Third Description", isStarred: false, track: nil, room: "lab", start: nil, end: nil, speakerIDs: [], tags: []),
        ]
    
    static var speakers: [SpeakerViewModel] { return SpeakerFixture.speakers }
    
    static let starredItems: [SessionViewModel] = items.filter { $0.isStarred }
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    weak var sessionStarsDataSourceDelegate: SessionStarsDataSourceDelegate?
    
    let numberOfSections: Int = 1
    
    func title(forSection section: Int) -> String? {
        return "Fixture Section Title"
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return SessionFixture.items.count
    }
    
    func viewModel(at indexPath: IndexPath) -> SessionViewModel {
        return SessionFixture.items[indexPath.item]
    }
    
    func indexPathOfSession(withSessionID sessionID: String) -> IndexPath? {
        let idx = SessionFixture.items.index(where: { return $0.sessionID == sessionID })
        let indexPath = idx.map { return IndexPath(item: $0, section: 0) }
        return indexPath
    }
    
    func isStarred(viewModel: SessionViewModel) -> Bool {
        let sessionIndexPath = indexPathOfSession(withSessionID: viewModel.sessionID)!
        let storedViewModel = SessionFixture.items[sessionIndexPath.item]
        return storedViewModel.isStarred
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        let sessionIndexPath = indexPathOfSession(withSessionID: viewModel.sessionID)!
        
        var updatedViewModel = SessionFixture.items[sessionIndexPath.item]
        updatedViewModel.isStarred = !updatedViewModel.isStarred
        
        SessionFixture.items[sessionIndexPath.item] = updatedViewModel
        
        return updatedViewModel
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        let sessionIndexPath = indexPathOfSession(withSessionID: viewModel.sessionID)!
        
        var updatedViewModel = SessionFixture.items[sessionIndexPath.item]
        updatedViewModel.isStarred = !updatedViewModel.isStarred
        
        SessionFixture.items[sessionIndexPath.item] = updatedViewModel
        
        return updatedViewModel
    }
}
