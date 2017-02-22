//
//  HLDateFormatter.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 2/17/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation


class HLDateFormatter {
    static let shared = HLDateFormatter()
    
    private init() { }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "hh:mm a  EEEE"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func humanReadableTimeSince(date: Date) -> String {
        let timeSince = abs(date.timeIntervalSinceNow)
        
        if timeSince < 60  {
            return "a few seconds ago"
        }
        
        if timeSince < 60 * 2 {
            return "a minute ago"
        }
        
        if timeSince < 60 * 60 {
            return "\(Int(timeSince/60)) minutes ago"
        }
        
        if timeSince < 60 * 60 * 2 {
            return "an hour ago"
        }
        
        if timeSince < 60 * 60 * 24 {
            return "\(Int(timeSince/(60 * 60))) hours ago"
        }

        if timeSince < 60 * 60 * 24 * 2 {
            return "yesterday"
        }
    
        return "once upon a time"
    }
    
    
}
