//
//  FirebaseStarsDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/26/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class FirebaseStarsDataSource: SessionStarsDataSource {
    fileprivate let databaseReference: FIRDatabaseReference
    
    weak var sessionStarsDataSourceDelegate: SessionStarsDataSourceDelegate?

    /// The IDs of sessions that have been starred.
    /// TODO: persistence
    fileprivate(set) var starredSessionIDs: Set<String> = [] {
        didSet {
            sessionStarsDataSourceDelegate?.sessionStarsDidUpdate(dataSource: self)
        }
    }
    
    var firebaseObservingUserID: String? {
        didSet {
            guard oldValue != firebaseObservingUserID else {
                return
            }
            
            if let handle = firebaseObservingHandle {
                databaseReference.removeObserver(withHandle: handle)
            }
            
            if let firebaseObservingUserID = firebaseObservingUserID {
                registerForObservingAgenda(forUserWithID: firebaseObservingUserID)
            }
        }
    }
    fileprivate var firebaseObservingHandle: UInt?
    
    init(databaseReference: FIRDatabaseReference = FIRDatabase.database().reference()) {
        self.databaseReference = databaseReference
    }
    
    deinit {
        if let observingHandle = firebaseObservingHandle {
            databaseReference.removeObserver(withHandle: observingHandle)
        }
    }
    
    // MARK: - SessionStarsDataSource
    
    func isStarred(viewModel: SessionViewModel) -> Bool {
        let didFindID = starredSessionIDs.contains(viewModel.sessionID)
        return didFindID
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        // Update our starred sessions, create a new view model, and return the new view model
        starredSessionIDs.insert(viewModel.sessionID)
        
        var vm = viewModel
        vm.isStarred = true
        return vm
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        // Update our starred sessions, create a new view model, and return the new view model
        starredSessionIDs.remove(viewModel.sessionID)
        
        var vm = viewModel
        vm.isStarred = false
        return vm
    }
}

private extension FirebaseStarsDataSource {
    func registerForObservingAgenda(forUserWithID userID: String) {
        firebaseObservingHandle = databaseReference.child("devfest2017").child("agendas").child(userID).observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            // what are the keys in this dictionary???
            guard let strongSelf = self, let keysAndSessionIDs = snapshot.value as? [String:String] else {
                return
            }
            
            strongSelf.starredSessionIDs = Set(keysAndSessionIDs.values)
        }
    }
}
