//
//  CLLocationCoordinate2D+fromLocation.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/7/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreLocation

public func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
    return left.latitude == right.latitude && left.longitude == right.longitude
}

extension CLLocationCoordinate2D {
    /* Convenience function to create a CLLocation from a Location object */
    static func from(location: Location) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(Double(location.latitude), Double(location.longitude))
    }
}
