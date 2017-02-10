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
    var location: String
    var time: String
    var descriptionStr: String
    var highlighted: Bool
    var location_id: Int
    
    override init() {
        name = "Event Name Here"
        location = "Location Here"
        time = "HH:MM DD"
        descriptionStr = "Description Here"
        highlighted = false
        location_id = 0
    }
    
    init(name: String, location : String, time: String, description: String, highlighted: Bool, location_id: Int) {
        self.name = name
        self.location = location
        self.time = time
        self.descriptionStr = description
        self.highlighted = highlighted
        self.location_id = location_id
    }
}
