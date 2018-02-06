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
        static let EVENT_START_TIME = Date(timeIntervalSince1970: 1517948820)
        static let HACKING_START_TIME = Date(timeIntervalSince1970: 0)
        static let HACKING_END_TIME = Date(timeIntervalSince1970: 0)
        static let EVENT_END_TIME = Date(timeIntervalSince1970: 0)

        static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 0)
        static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 0)
        static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 0)
        static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 0)
        static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 0)
        static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 0)
    }
}
