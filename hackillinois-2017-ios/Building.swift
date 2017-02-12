//
//  Building.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/7/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import MapKit

class Building: NSObject, MKAnnotation {
    var title: String?
    var longName: String?
    var coordinate: CLLocationCoordinate2D
    var address: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, shortName: String, address: String) {
        self.title = shortName
        self.longName = title
        self.coordinate = coordinate
        self.address = address
    }
    
    /* Convenience initializer to create a Building object from a Location object */
    init(location: Location) {
        self.title = location.shortName
        self.longName = location.name
        self.coordinate =
            CLLocationCoordinate2DMake(Double(location.latitude), Double(location.longitude))
    }
}
