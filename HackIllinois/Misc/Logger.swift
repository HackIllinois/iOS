//
//  Logger.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/4/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import os

struct Logger {
    static var api           = OSLog(subsystem: "org.hackillinois.ios", category: "api")
    static var notifications = OSLog(subsystem: "org.hackillinois.ios", category: "notifications")
    static var ui            = OSLog(subsystem: "org.hackillinois.ios", category: "ui")
}
