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
    
    func viewModel(atIndex index: Int) -> SessionViewModel
    func indexOfSession(withSessionID sessionID: String) -> Int?
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
    
    let sections: Int = 1
    var shouldIncludeOnlyStarred: Bool = false
    
    func numberOfItems(inSection section: Int) -> Int {
        return SessionFixture.items.count
    }
    
    func viewModel(atIndex index: Int) -> SessionViewModel {
        return SessionFixture.items[index]
    }
    
    func indexOfSession(withSessionID sessionID: String) -> Int? {
        return SessionFixture.items.index(where: { return $0.sessionID == sessionID })
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        let sessionIndex = indexOfSession(withSessionID: viewModel.sessionID)!
        
        var updatedViewModel = SessionFixture.items[sessionIndex]
        updatedViewModel.isStarred = !updatedViewModel.isStarred
        
        SessionFixture.items[sessionIndex] = updatedViewModel
        
        return updatedViewModel
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        let sessionIndex = indexOfSession(withSessionID: viewModel.sessionID)!
        
        var updatedViewModel = SessionFixture.items[sessionIndex]
        updatedViewModel.isStarred = !updatedViewModel.isStarred
        
        SessionFixture.items[sessionIndex] = updatedViewModel
        
        return updatedViewModel
    }
}