//
//  Constants.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/24/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI

// MARK: - Constants
class HIConstants {

    // Times for HackIllinois 2020 (backup if API call doesn't work)
    static let EVENT_START_TIME = Date(timeIntervalSince1970: 1582927200) // Friday, February 28, 2020 1550872800 4:00:00 PM GMT-06:00
    static let HACKING_START_TIME = Date(timeIntervalSince1970: 1582952400) // Friday, February 28, 2020 11:00:00 PM GMT-06:00
    static let HACKING_END_TIME = Date(timeIntervalSince1970: 1583078400) // Sunday, March 1, 2020 10:00:00 AM GMT-06:00
    static let EVENT_END_TIME = Date(timeIntervalSince1970: 1583103600) // Sunday, March 1, 2020 05:00:00 PM GMT-06:00

    static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1582869600) // Friday, February 28, 2020 12:00:00 AM GMT-06:00
    static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1582955999) // Friday, February 28, 2020 11:59:59 PM GMT-06:00
    static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1582956000) // Saturday, February 29, 2020 12:00:00 AM GMT-06:00
    static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1583042399) // Saturday, February 29, 2020 11:59:59 PM GMT-06:00
    static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1583042400) // Sunday, March 1, 2020 12:00:00 AM GMT-06:00
    static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1583128799) // Sunday, March 1, 2020 11:59:59 PM GMT-06:006:00

    // Keys
    static let STORED_ACCOUNT_KEY = "org.hackillinois.ios.active_account"
    static let APPLICATION_INSTALLED_KEY = "org.hackillinois.ios.application_installed"
    static func PASS_PROMPTED_KEY(user: HIUser) -> String {
        return "org.hackillinois.ios.pass_prompted_\(user.id)"
    }
}
