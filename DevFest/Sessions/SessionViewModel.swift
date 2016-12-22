//
//  SessionViewModel.swift
//  DevFest
//
//  Created by Brendon Justin on 11/24/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

struct SessionViewModel {
    let sessionID: String
    let title: String
    let description: String?
    
    let color: UIColor
    var isStarred: Bool
    
    // Optional items
    let category: String?
    let room: String?
    let start: Date?
    let end: Date?
    let speakers: [SpeakerViewModel]
    let tags: [String]
    
    var hasEnded: Bool {
        // Assume events without a start time don't end
        guard let start = start else {
            return false
        }
        
        // assume a duration of 8 hours if we don't have an end time
        let end = self.end ?? start.addingTimeInterval(8 * 60 * 60)
        let hasEnded = Date() > end
        return hasEnded
    }
    
    func durationString(using dateFormatter: DateFormatter) -> String? {
        switch (start, end) {
        case let (start?, end?):
            let format = NSLocalizedString("%@ - %@", comment: "Time range, e.g. for session start and end")
            let stringStart = dateFormatter.string(from: start)
            let stringEnd = dateFormatter.string(from: end)
            let formatted = String(format: format, stringStart, stringEnd)
            return formatted
        case let (start?, nil):
            let format = NSLocalizedString("Starts %@", comment: "Start time, e.g. for session start")
            let stringDate = dateFormatter.string(from: start)
            let formatted = String(format: format, stringDate)
            return formatted
        case let (nil, end?):
            let format = NSLocalizedString("Ends %@", comment: "Start time, e.g. for session start")
            let stringDate = dateFormatter.string(from: end)
            let formatted = String(format: format, stringDate)
            return formatted
        case (nil, nil):
            return nil
        }
    }
}
