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
    /// TODO: persistence aside from Firebase
    fileprivate(set) var starredSessionIDs: Set<String> = [] {
        didSet {
            // Take no action if the value hasn't actually changed.
            guard starredSessionIDs != oldValue else {
                return
            }
            
            sessionStarsDataSourceDelegate?.sessionStarsDidUpdate(dataSource: self)
            if let firebaseUserID = firebaseUserID {
                updateStarsInFirebase(userID: firebaseUserID)
            }
        }
    }
    
    fileprivate var firebaseUserID: String?
    
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
    
    /**
     Set (or remove) the user's Firebase ID, so we can sync (or stop syncing) their starred sessions to Firebase.
     */
    func setFirebaseUserID(_ userID: String?, shouldMergeLocalAndRemoteStarsOnce: Bool) {
        if let handle = firebaseObservingHandle {
            databaseReference.removeObserver(withHandle: handle)
        }
        
        firebaseUserID = userID
        if let firebaseUserID = firebaseUserID {
            registerForObservingAgenda(forUserWithID: firebaseUserID, shouldMergeLocalAndRemoteStartsOnce: shouldMergeLocalAndRemoteStarsOnce)
        }
    }
}

private extension FirebaseStarsDataSource {
    func updateStarsInFirebase(userID: String) {
        var starsDict: [String:[String:Any]] = [:]
        for sessionID in starredSessionIDs {
            starsDict[sessionID] = ["value":true]
        }
        
        let agendasChild = "\(userID)"
        databaseReference.child("devfest2017").child("agendas").child(agendasChild).setValue(starsDict)
    }
    
    func registerForObservingAgenda(forUserWithID userID: String, shouldMergeLocalAndRemoteStartsOnce: Bool) {
        var shouldMerge = shouldMergeLocalAndRemoteStartsOnce
        
        let agendasChild = "\(userID)"
        firebaseObservingHandle = databaseReference.child("devfest2017").child("agendas").child(agendasChild).observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            // Assume a format like [{ "sessionIDGoesHere" : { "value" : true} }, { "anotherSessionID" : { "value" : true } }]
            guard let strongSelf = self, let sessionIDsDicts = snapshot.value as? [String:[String:Any]] else {
                return
            }
            
            let sessionIDs = sessionIDsDicts.keys
            let firebaseStarredSessionIDs = Set(sessionIDs)
            let starredSessionIDs: Set<String>
            if shouldMerge {
                shouldMerge = false
                starredSessionIDs = strongSelf.starredSessionIDs.union(firebaseStarredSessionIDs)
            } else {
                starredSessionIDs = firebaseStarredSessionIDs
            }
            strongSelf.starredSessionIDs = starredSessionIDs
        }
    }
}
