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
    
    var color: UIColor {
        let defaultColor = UIColor(red: 0x11 / 255, green: 0x11 / 255, blue: 0x11 / 255, alpha: 1)
        guard let track = track else {
            return defaultColor
        }
        
        switch track.localizedLowercase {
        case "all":
            return defaultColor
        case "android":
            return UIColor(red: 0x54 / 255, green: 0x8b / 255, blue: 0x2f / 255, alpha: 1)
        case "cloud":
            return UIColor(red: 0xb4 / 255, green: 0xb4 / 255, blue: 0xb4 / 255, alpha: 1)
        case "design":
            return UIColor(red: 0x00 / 255, green: 0xb8 / 255, blue: 0xdd / 255, alpha: 1)
        case "iot":
            return UIColor(red: 0x95 / 255, green: 0x37 / 255, blue: 0xff / 255, alpha: 1)
        case "keynote":
            return UIColor(red: 0xf4 / 255, green: 0x43 / 255, blue: 0x36 / 255, alpha: 1)
        case "web":
            return UIColor(red: 0xff / 255, green: 0x8f / 255, blue: 0x00 / 255, alpha: 1)
        default:
            return defaultColor
        }
    }
    var isStarred: Bool
    
    // Optional items
    let track: String?
    let room: String?
    let start: Date?
    let end: Date?
    let speakerIDs: [String]
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
