//
//  EventConstants.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

/*
 * This file contains various constants to be used for the Application
 * Modify this file for various behaviorial changes such as the color of the tab bar
 */

import Foundation
import UIKit


/* UI/UX */
let timeoutIntervalSeconds: UInt64 = 10 // Timeout interval for network calls, in seconds

/* Geocoordinates */
let centerOfEventLatitude: Double = 40.1137074
let centerOfEventLongitude: Double = -88.2264893

/* Google maps stroke color */
let strokeWidth: CGFloat = 6.0

let defaultHeight = 2000.0
let defaultPitch: CGFloat = 0.0
let defaultHeading = 0.0

/* Hackathon Information */
let university = "University+of+Illinois+at+Urbana+Champaign" // This will be encoded as an URL, so spaces should be delimited by +'s

/* Hackathon timestamps */
// pulled from the api and initialized
var HACKATHON_BEGIN_TIME = Date()
var HACKING_BEGIN_TIME = Date()
var HACKING_END_TIME = Date()
var HACKATHON_END_TIME = Date()
