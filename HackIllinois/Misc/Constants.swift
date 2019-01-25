//
//  Constants.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

// MARK: - Constants
struct HIConstants {
    // Times
    static let EVENT_START_TIME = Date(timeIntervalSince1970: 1519423200) // 2018-02-23T16:00:00-0600 = 2018-02-23T22:00:00+0000
    static let HACKING_START_TIME = Date(timeIntervalSince1970: 1519448400) // 2018-02-23T23:00:00-0600 = 2018-02-24T05:00:00+0000
    static let HACKING_END_TIME = Date(timeIntervalSince1970: 1519578000) // 2018-02-25T11:00:00-0600 = 2018-02-25T17:00:00+0000
    static let EVENT_END_TIME = Date(timeIntervalSince1970: 1519599600) // 2018-02-25T17:00:00-0600 = 2018-02-25T23:00:00+0000

    static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1519365600) // 2018-02-23T00:00:00-0600 = 2018-02-23T06:00:00+0000
    static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1519451999) // 2018-02-23T23:59:59-0600 = 2018-02-24T05:59:59+0000
    static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1519452000) // 2018-02-24T00:00:00-0600 = 2018-02-24T06:00:00+0000
    static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1519538399) // 2018-02-24T23:59:59-0600 = 2018-02-25T05:59:59+0000
    static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1519538400) // 2018-02-25T00:00:00-0600 = 2018-02-25T06:00:00+0000
    static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1519624799) // 2018-02-25T23:59:59-0600 = 2018-02-26T05:59:59+0000

    // Keychain
    static let STORED_ACCOUNT_KEY = "org.hackillinois.ios.active_account"
    static let APPLICATION_INSTALLED_KEY = "org.hackillinois.ios.application_installed"
}
