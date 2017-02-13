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
        if let time = feed.startTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            timeStr = dateFormatter.string(from: time)
        }
        
        self.name = feed.name ?? ""
        self.time = timeStr
        self.descriptionStr = feed.description_ ?? ""
        self.highlighted = false // TODO
        self.locations = []
        
        if let locations = feed.locations {
            for location in locations {
                let location = location as! Location
                self.locations.append(
                    DayItemLocation(id: Int(location.id) + 1, name: location.shortName)
                )
            }
        }
    }
    
    func setImage(title: String, url: String) {
        self.imageUrl = url
        self.imageTitle = title
    }
    
    func setImage(title: String, fileName: String) {
        self.imageFileName = fileName
    }
}
