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
    var shouldIncludeOnlyStarred: Bool { get }
    
    func viewModel(at indexPath: IndexPath) -> SessionViewModel
    func indexPathOfSession(withSessionID sessionID: String) -> IndexPath?
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel
}

protocol SessionDataSourceDelegate: class {
    func sessionDataSourceDidUpdate()
}

final class SessionFixture: SessionDataSource {
    static var items: [SessionViewModel] = [
        SessionViewModel(sessionID: "one", title: "First Session", description: "First Session Description", color: .green, isStarred: false, category: "android", room: "auditorium", start: nil, end: nil, speakers: [speakers[0]], tags: []),
        SessionViewModel(sessionID: "two", title: "Session Two", description: "Session Two Description", color: .blue, isStarred: true, category: "design", room: "classroom 1", start: nil, end: nil, speakers: [], tags: []),
        SessionViewModel(sessionID: "three", title: "Session the Third", description: "Session the Third Description", color: .black, isStarred: false, category: nil, room: "lab", start: nil, end: nil, speakers: [], tags: []),
        ]
    
    static var speakers: [SpeakerViewModel] { return SpeakersViewController.Fixture.speakers }
    
    static let starredItems: [SessionViewModel] = items.filter { $0.isStarred }
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    
    let numberOfSections: Int = 1
    var shouldIncludeOnlyStarred: Bool = false
    
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
