//
//  FirebaseSessionDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/21/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseSessionDataSource: SessionDataSource {
    let databaseReference: FIRDatabaseReference
    let shouldIncludeOnlyStarred: Bool
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    
    var sections: Int {
        return 1
    }
    
    var sessions: [SessionViewModel] = []
    var starredSessions: [SessionViewModel] {
        return sessions.filter { vm in vm.isStarred }
    }
    var workingSessions: [SessionViewModel] {
        if shouldIncludeOnlyStarred {
            return starredSessions
        } else {
            return sessions
        }
    }
    
    init(databaseReference: FIRDatabaseReference = FIRDatabase.database().reference(), shouldIncludeOnlyStarred: Bool = false) {
        self.databaseReference = databaseReference
        self.shouldIncludeOnlyStarred = shouldIncludeOnlyStarred
        
        databaseReference.child("devfest2017").child("schedule").observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            guard let dict = snapshot.value as? [String:Any], let strongSelf = self else {
                return
            }
            
            var newSessions: [SessionViewModel] = []
            
            for (key, value) in dict {
                if let dictValue = value as? [String:Any], let viewModel = SessionViewModel(id: key, firebaseData: dictValue) {
                    newSessions.append(viewModel)
                }
            }
            
            strongSelf.sessions = newSessions
            strongSelf.sessionDataSourceDelegate?.sessionDataSourceDidUpdate()
        }
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return workingSessions.count
    }
    
    func viewModel(atIndex index: Int) -> SessionViewModel {
        let vm = workingSessions[index]
        return vm
    }
    
    func indexOfSession(withSessionID sessionID: String) -> Int? {
        let idx = workingSessions.index(where: { vm in vm.sessionID == sessionID })
        return idx
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        // Update the session, create a new view model, and return the new view model
        
        // For now, just update the view model
        var vm = viewModel
        vm.isStarred = true
        return vm
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        // Update the session, create a new view model, and return the new view model
        
        // For now, just update the view model
        var vm = viewModel
        vm.isStarred = false
        return vm
    }
}

extension SessionViewModel {
    init?(id: String, firebaseData dict: [String:Any]) {
        guard let title = dict["title"] as? String else {
                return nil
        }
        
        let color: UIColor = .black
        let description = dict["description"] as? String
        let category = dict["category"] as? String
        let room = dict["room"] as? String
        
        // start/end times
        let startString = dict["startTime"] as? String
        let start = startString.map { _ in Date() }
        let endString = dict["endTime"] as? String
        let end = endString.map { _ in Date() }
        
        let tags = dict["tags"] as? [String]
        
        let isStarred = false
        
        self.init(sessionID: id, title: title, description: description, color: color, isStarred: isStarred, category: category, room: room, start: start, end: end, speakers: [], tags: tags ?? [])
    }
}
