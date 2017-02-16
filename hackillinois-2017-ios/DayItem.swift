//
//  DayItem.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation

class DayItem: NSObject {
    var name: String
    var time: String
    var descriptionStr: String
    var highlighted: Bool
    var locations = [DayItemLocation]()
    var imageUrl: String?
    var imageTitle: String?
    var imageFileName: String?
    var timestamp: TimeInterval = 0
    var dayOfWeek: Int = 0
    
    override init() {
        name = "Event Name Here"
        time = "HH:MM DD"
        descriptionStr = "Description Here"
        highlighted = false
    }
    
    init(name: String, time: String, description: String, highlighted: Bool, locations: [DayItemLocation]) {
        // Note: locations.count should be <= 3
        assert(locations.count <= 3)
        
        self.name = name
        self.time = time
        self.descriptionStr = description
        self.highlighted = highlighted
        self.locations = locations
    }
    
    init(feed: Feed) {
        var timeStr = ""
        let time = feed.startTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeStr = dateFormatter.string(from: time)
        
        self.name = feed.name 
        self.time = timeStr
        self.timestamp = feed.startTime.timeIntervalSince1970
        self.descriptionStr = feed.description_ 
        self.highlighted = DayItem.isTimeBetween(first: feed.startTime, second: feed.endTime)
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components = calendar.components(.weekday, from: feed.startTime)
        self.dayOfWeek = components.weekday!
        
        self.locations = []
        
        let locations = feed.locations
        for location in locations {
            let location = location as! Location
            self.locations.append(
                DayItemLocation(id: Int(location.id) + 1, name: location.shortName)
            )
        }
    }
    
    func setImage(title: String, url: String) {
        self.imageUrl = url
        self.imageTitle = title
    }
    
    func setImage(title: String, fileName: String) {
        self.imageFileName = fileName
    }
    
    static func isTimeBetween(first: Date, second: Date) -> Bool {
        let current = Date()
        return current.compare(first) == .orderedDescending &&
            current.compare(second) == .orderedAscending
        
    }
}
