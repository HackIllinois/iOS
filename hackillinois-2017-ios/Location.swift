
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
import MapKit


class Location: NSManagedObject, MKAnnotation {

    /* Convenience updating function */
    func initialize(id: Int16, latitude: Float, longitude: Float, name: String, shortName: String, feeds: NSSet) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shortName = shortName
        self.feeds = feeds
        self.id = id
    }
    
    /* Convenience updating function */
    @nonobjc func initialize(id: Int16, latitude: Float, longitude: Float, name: String, shortName: String, feeds: [Feed]) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shortName = shortName
        self.id  = id
        self.feeds = NSSet(array: feeds)
    }
    
    func update(id: Int16, latitude: Float, longitude: Float, name: String, shortName: String, feeds: [Feed]) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shortName = shortName
        self.id = id
        self.feeds = NSSet(array: feeds)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
    }

    var title: String? {
        return name
    }
    
    var address: String? {
        return LocationIdMapper.addressMappings[self.id]
    }
}
