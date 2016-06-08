//
//  Location.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class Location: NSManagedObject {

    /* Convenience updating function */
    func initialize(latitude: NSNumber, longitude: NSNumber, name: String, feeds: NSSet) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.feeds = feeds
    }
    
    /* Convenience updating function */
    @nonobjc func initialize(latitude: NSNumber, longitude: NSNumber, name: String, feeds: [Feed]) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.feeds = NSSet(array: feeds)
    }
}
