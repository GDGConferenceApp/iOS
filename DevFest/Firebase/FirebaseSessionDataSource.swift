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
    /// The date on which all firebase sessions are assumed to take place
    private let firebaseDate: Date
    private let sectionHeaderDateFormatter: DateFormatter
    /// `false` by default.
    /// Changing this value requires that any users of this class throw out and completely
    /// reload the data they have gotten from this class.
    var shouldIncludeOnlyStarred: Bool = false
    
    weak var sessionDataSourceDelegate: SessionDataSourceDelegate?
    
    var numberOfSections: Int {
        return sessionsByStart.keys.count
    }
    
    private var sessions: [SessionViewModel] = []
    private var starredSessions: [SessionViewModel] {
        return sessions.filter { vm in vm.isStarred }
    }
    
    /// The working set of sessions we're using, i.e. all sessions or only starred sessions.
    private var workingSessions: [SessionViewModel] {
        if shouldIncludeOnlyStarred {
            return starredSessions
        } else {
            return sessions
        }
    }
    
    /// `workingSessions` grouped by each session's startTime
    private var sessionsByStart: [Date:[SessionViewModel]] {
        var collected: [Date:[SessionViewModel]] = [:]
        for session in workingSessions {
            guard let startTime = session.start else {
                // Don't make sections for sessions without a start time
                continue
            }
            
            collected[startTime, defaulting: []].append(session)
        }
        
        return collected
    }
    
    init(databaseReference: FIRDatabaseReference = FIRDatabase.database().reference(), firebaseDateFormatter: DateFormatter, firebaseDate: Date, sectionHeaderDateFormatter: DateFormatter) {
        self.databaseReference = databaseReference
        self.firebaseDateFormatter = firebaseDateFormatter
        self.firebaseDate = firebaseDate
        self.sectionHeaderDateFormatter = sectionHeaderDateFormatter
        
        databaseReference.child("devfest2017").child("schedule").observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            guard let dict = snapshot.value as? [String:Any], let strongSelf = self else {
                return
            }
            
            var newSessions: [SessionViewModel] = []
            
            for (key, value) in dict {
                if let dictValue = value as? [String:Any],
                    let viewModel = SessionViewModel(id: key, firebaseData: dictValue, firebaseDateFormatter: firebaseDateFormatter, firebaseDate: firebaseDate) {
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
        let dateForSection = date(forSection: section)
        let title = sectionHeaderDateFormatter.string(from: dateForSection)
        return title
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
    init?(id: String, firebaseData dict: [String:Any], firebaseDateFormatter: DateFormatter, firebaseDate: Date) {
        guard let title = dict["title"] as? String else {
            return nil
        }
        
        let color: UIColor = .black
        let description = dict["description"] as? String
        let category = dict["category"] as? String
        let room = dict["room"] as? String
        
        // start/end times
        let startString = dict["startTime"] as? String
        let startWithoutDate = startString.flatMap(firebaseDateFormatter.date)
        let endString = dict["endTime"] as? String
        let endWithoutDate = endString.flatMap(firebaseDateFormatter.date)
        
        let tags = dict["tags"] as? [String]
        
        let speakerIDs = dict["speakers"] as? [String]
        
        let isStarred = false
        
        let calendar = Calendar(identifier: .iso8601)
        let firebaseDateComponents = calendar.dateComponents(in: firebaseDateFormatter.timeZone, from: firebaseDate)
        
        func update(_ components: DateComponents, withHourAndMinuteFrom date: Date) -> DateComponents {
            let withoutDateHourAndMinute = calendar.dateComponents([.hour, .minute], from: date)
            var components = components
            components.hour = withoutDateHourAndMinute.hour
            components.minute = withoutDateHourAndMinute.minute
            return components
        }
        
        let start: Date?
        if let startWithoutDate = startWithoutDate {
            let startComponents = update(firebaseDateComponents, withHourAndMinuteFrom: startWithoutDate)
            start = calendar.date(from: startComponents)
        } else {
            start = nil
        }
        
        let end: Date?
        if let endWithoutDate = endWithoutDate {
            let endComponents = update(firebaseDateComponents, withHourAndMinuteFrom: endWithoutDate)
            end = calendar.date(from: endComponents)
        } else {
            end = nil
        }
        
        self.init(sessionID: id, title: title, description: description, color: color, isStarred: isStarred, category: category, room: room, start: start, end: end, speakerIDs: speakerIDs ?? [], tags: tags ?? [])
    }
}
