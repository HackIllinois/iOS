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
    
    override init() {
        name = "Event Name Here"
        location = "Location Here"
        time = "HH:MM DD"
    }
    
    init(name: String, location : String, time: String) {
        self.name = name
        self.location = location
        self.time = time
    }
}