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
    static let EVENT_START_TIME = Date(timeIntervalSince1970: 1550858400) // Friday, February 22, 2019 12:00:00 PM GMT-06:00
    static let HACKING_START_TIME = Date(timeIntervalSince1970: 1550887200) // Friday, February 22, 2019 8:00:00 PM GMT-06:00
    static let HACKING_END_TIME = Date(timeIntervalSince1970: 1551024000) // Sunday, February 24, 2019 10:00:00 AM GMT-06:00
    static let EVENT_END_TIME = Date(timeIntervalSince1970: 1551031200) // Sunday, February 24, 2019 12:00:00 PM GMT-06:00

    static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1550815200) // Friday, February 22, 2019 12:00:00 AM GMT-06:00
    static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1550901599) // Friday, February 22, 2019 11:59:59 PM GMT-06:00
    static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1550901600) // Saturday, February 23, 2019 12:00:00 AM GMT-06:00
    static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1550987999) // Saturday, February 23, 2019 11:59:59 PM GMT-06:00
    static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1550988000) // Sunday, February 24, 2019 12:00:00 AM GMT-06:00
    static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1551074399) // Sunday, February 24, 2019 11:59:59 PM GMT-06:00

    // Keys
    static let STORED_ACCOUNT_KEY = "org.hackillinois.ios.active_account"
    static let APPLICATION_INSTALLED_KEY = "org.hackillinois.ios.application_installed"
    static func PASS_PROMPTED_KEY(user: HIUser) -> String {
        return "org.hackillinois.ios.pass_prompted_\(user.id)"
    }
}
