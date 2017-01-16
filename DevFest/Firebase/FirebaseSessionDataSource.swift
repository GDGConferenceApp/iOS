//
//  FirebaseSessionDataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/21/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import FirebaseDatabase

/**
 Provides sessions from Firebase. Does not ever change session starred status.
 
 The `star`/`unstar` methods do nothing.
 */
class FirebaseSessionDataSource: SessionDataSource {
    private let databaseReference: FIRDatabaseReference
    private let firebaseDateFormatter: DateFormatter
    private let sectionHeaderDateFormatter: DateFormatter
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    
    var numberOfSections: Int {
        return sessionsByStart.keys.count
    }
    
    private var sessions: [SessionViewModel] = []
    
    /// `workingSessions` grouped by each session's startTime
    private var sessionsByStart: [Date:[SessionViewModel]] {
        var collected: [Date:[SessionViewModel]] = [:]
        for session in sessions {
            let startTime = session.start ?? .distantPast
            
            collected[startTime, defaulting: []].append(session)
        }
        
        return collected
    }
    
    init(databaseReference: FIRDatabaseReference = FIRDatabase.database().reference(), firebaseDateFormatter: DateFormatter, sectionHeaderDateFormatter: DateFormatter) {
        self.databaseReference = databaseReference
        self.firebaseDateFormatter = firebaseDateFormatter
        self.sectionHeaderDateFormatter = sectionHeaderDateFormatter
        
        databaseReference.child("devfest2017").child("schedule").observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            guard let dict = snapshot.value as? [String:Any], let strongSelf = self else {
                return
            }
            
            var newSessions: [SessionViewModel] = []
            
            for (key, value) in dict {
                if let dictValue = value as? [String:Any],
                    let viewModel = SessionViewModel(id: key, firebaseData: dictValue, firebaseDateFormatter: firebaseDateFormatter) {
                    newSessions.append(viewModel)
                }
            }
            
            strongSelf.sessions = newSessions
            strongSelf.sessionDataSourceDelegate?.sessionDataSourceDidUpdate()
        }
    }
    
    private func date(forSection section: Int) -> Date {
        let dateForSection = sessionsByStart.keys.sorted()[section]
        return dateForSection
    }
    
    func title(forSection section: Int) -> String? {
        if case let dateForSection = date(forSection: section), dateForSection != .distantPast {
            let title = sectionHeaderDateFormatter.string(from: dateForSection)
            return title
        } else {
            return NSLocalizedString("Start time not listed", comment: "Section header for Sessions without a start time")
        }
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return sessionsByStart[date(forSection: section)]!.count
    }
    
    func viewModel(at indexPath: IndexPath) -> SessionViewModel {
        let vm = sessionsByStart[date(forSection: indexPath.section)]![indexPath.item]
        return vm
    }
    
    func indexPathOfSession(withSessionID sessionID: String) -> IndexPath? {
        var indexPath: IndexPath?
        
        for section in 0..<numberOfSections {
            let date = self.date(forSection: section)
            let sessionsForStart = sessionsByStart[date]!
            
            guard let foundSessionIdx = sessionsForStart.index(where: { vm in vm.sessionID == sessionID }) else {
                continue
            }
            
            indexPath = IndexPath(item: foundSessionIdx, section: section)
        }
        
        return indexPath
    }
    
    func starSession(for viewModel: SessionViewModel) -> SessionViewModel {
        return viewModel
    }
    
    func unstarSession(for viewModel: SessionViewModel) -> SessionViewModel {
        return viewModel
    }
}

extension SessionViewModel {
    init?(id: String, firebaseData dict: [String:Any], firebaseDateFormatter: DateFormatter) {
        guard let title = dict["title"] as? String else {
            return nil
        }
        
        let color: UIColor = .black
        let description = dict["description"] as? String
        let track = dict["track"] as? String
        let room = dict["room"] as? String
        
        // start/end times
        let startString = dict["startTime"] as? String
        let start: Date? = startString.flatMap { $0.nonEmptyString }.flatMap(firebaseDateFormatter.date)
        let endString = dict["endTime"] as? String
        let end: Date? = endString.flatMap { $0.nonEmptyString }.flatMap(firebaseDateFormatter.date)
        
        let tags = dict["tags"] as? [String]
        
        let speakerIDs = dict["speakers"] as? [String]
        
        let isStarred = false
        
        self.init(sessionID: id, title: title, description: description, color: color, isStarred: isStarred, track: track, room: room, start: start, end: end, speakerIDs: speakerIDs ?? [], tags: tags ?? [])
    }
}

private extension String {
    var nonEmptyString: String? {
        if self == "" {
            return nil
        } else {
            return self
        }
    }
}
