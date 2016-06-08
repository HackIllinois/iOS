//
//  MKMapCamera+initFromLocation.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/7/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKMapCamera {
    /* 
     * Convenience function to create a MKMapCamera centered at a Location 
     * Some constants are pulled from MainConstants.swift
     */
    class func from(location location: Location) -> MKMapCamera {
        return MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2D.from(location: location), fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
    }
}