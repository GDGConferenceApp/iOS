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
    
    var shouldIncludeOnlyStarred = false
    
    var sections: Int {
        return 1
    }
    
    init(databaseReference: FIRDatabaseReference = FIRDatabase.database().reference()) {
        self.databaseReference = databaseReference
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return 0
    }
    
    func viewModel(atIndex index: Int) -> SessionViewModel {
        let id = ""
        let title = ""
        let color = UIColor.black
        let isStarred = false
        let category = "hello"
        let room = "auditorium"
        let start: Date? = nil
        let end: Date? = nil
        let speakers: [SpeakerViewModel] = []
        let tags: [String] = []
        
        let vm = SessionViewModel(sessionID: id, title: title, color: color, isStarred: isStarred, category: category, room: room, start: start, end: end, speakers: speakers, tags: tags)
        return vm
    }
    
    func indexOfSession(withSessionID sessionID: String) -> Int? {
        return nil
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
