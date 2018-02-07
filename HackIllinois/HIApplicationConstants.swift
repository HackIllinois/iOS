//
//  HIApplicationConstants.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/6/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Operators
infix operator <-

// MARK: - Constants
struct HIApplication {
    struct Color {
        static let paleBlue = UIColor(named: "paleBlue")!
        static let hotPink = UIColor(named: "hotPink")!
        static let darkIndigo = UIColor(named: "darkIndigo")!
        static let lightPeriwinkle = UIColor(named: "lightPeriwinkle")!
        static let white = UIColor(named: "white")!
        static let darkBlueGrey = UIColor(named: "darkBlueGrey")!
        static let darkBlueGrey70 = UIColor(named: "darkBlueGrey70")!
    }

    struct Configuration {
        static let EVENT_START_TIME = Date(timeIntervalSince1970: 1519423200) // 2018-02-23T16:00:00-0600 = 2018-02-23T22:00:00+0000
        static let HACKING_START_TIME = Date(timeIntervalSince1970: 1519444800) // 2018-02-23T20:00:00-0600 = 2018-02-24T04:00:00+0000
        static let HACKING_END_TIME = Date(timeIntervalSince1970: 1519578000) // 2018-02-25T11:00:00-0600 = 2018-02-25T17:00:00+0000
        static let EVENT_END_TIME = Date(timeIntervalSince1970: 1519599600) // 2018-02-25T17:00:00+0000 = 2018-02-25T23:00:00+0000

        static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1519365600) // 2018-02-23T00:00:00-0600 = 2018-02-23T06:00:00+0000
        static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1519451999) // 2018-02-23T23:59:59-0600 = 2018-02-24T05:59:59+0000
        static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1519452000) // 2018-02-24T00:00:00-0600 = 2018-02-24T06:00:00+0000
        static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1519538399) // 2018-02-24T23:59:59-0600 = 2018-02-25T05:59:59+0000
        static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1519538400) // 2018-02-25T00:00:00-0600 = 2018-02-25T06:00:00+0000
        static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1519624799) // 2018-02-25T23:59:59-0600 = 2018-02-26T05:59:59+0000
    }
}
