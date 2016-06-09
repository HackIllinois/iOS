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
    var short: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, shortName: String) {
        self.title = title
        self.short = shortName
        self.coordinate = coordinate
    }
    
    /* Convenience initializer to create a Building object from a Location object */
    init(location: Location) {
        self.title = location.name
        self.coordinate =
            CLLocationCoordinate2DMake(Double(location.latitude), Double(location.longitude))
    }
}
