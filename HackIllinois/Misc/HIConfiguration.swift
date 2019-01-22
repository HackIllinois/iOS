//
//  HIConfiguration.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/6/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

// MARK: - Constants
struct HIConfiguration {
    static let EVENT_START_TIME = Date(timeIntervalSince1970: 1550858400) // Friday, February 22, 2019 12:00:00 PM GMT-06:00
    static let HACKING_START_TIME = Date(timeIntervalSince1970: 1550887200) // Friday, February 22, 2019 8:00:00 PM GMT-06:00
    static let HACKING_END_TIME = Date(timeIntervalSince1970: 1551024000) // Sunday, February 24, 2019 10:00:00 AM GMT-06:00
    static let EVENT_END_TIME = Date(timeIntervalSince1970: 1551031200) // Sunday, February 24, 2019 12:00:00 PM GMT-06:00

    static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1550815200) // 2018-02-23T00:00:00-0600 = 2018-02-23T06:00:00+0000
    static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1550901599) // 2018-02-23T23:59:59-0600 = 2018-02-24T05:59:59+0000
    static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1550901600) // 2018-02-24T00:00:00-0600 = 2018-02-24T06:00:00+0000
    static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1550987999) // 2018-02-24T23:59:59-0600 = 2018-02-25T05:59:59+0000
    static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1550988000) // 2018-02-25T00:00:00-0600 = 2018-02-25T06:00:00+0000
    static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1551074399) // 2018-02-25T23:59:59-0600 = 2018-02-26T05:59:59+0000
}
