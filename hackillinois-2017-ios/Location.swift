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
    func initialize(latitude: NSNumber, longitude: NSNumber, name: String, shortName: String, feeds: NSSet, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shortName = shortName
        self.feeds = feeds
        self.address = address
    }
    
    /* Convenience updating function */
    @nonobjc func initialize(latitude: NSNumber, longitude: NSNumber, name: String, shortName: String, address: String, feeds: [Feed]) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shortName = shortName
        self.address = address
        self.feeds = NSSet(array: feeds)
    }
}
