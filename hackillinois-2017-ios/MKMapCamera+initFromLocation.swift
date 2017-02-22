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
    class func from(location: Location) -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
    }
}
