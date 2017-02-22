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
