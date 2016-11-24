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
}
