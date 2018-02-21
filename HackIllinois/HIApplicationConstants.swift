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

// MARK: - Notifications
extension Notification.Name {
    static let themeDidChange = Notification.Name("HIApplicationThemeDidChange")
}

// MARK: - Constants
struct HIApplication {
    struct Palette {
        let primary: UIColor
        let accent: UIColor
        let background: UIColor
        let contentBackground: UIColor
        let actionBackground: UIColor
        let overlay: UIColor
        let dark: UIColor

        private static let dayPalette = HIApplication.Palette(
            primary: UIColor(named: "darkIndigo")!,
            accent: UIColor(named: "hotPink")!,
            background: UIColor(named: "paleBlue")!,
            contentBackground: UIColor(named: "white")!,
            actionBackground: UIColor(named: "lightPeriwinkle")!,
            overlay: UIColor(named: "darkBlueGrey")!,
            dark: UIColor(named: "darkIndigo")!
        )

        private static let nightPalette = HIApplication.Palette(
            primary: UIColor.white,
            accent: UIColor(named: "hotPink")!,
            background: UIColor.darkGray,
            contentBackground: UIColor.lightGray,
            actionBackground: UIColor.gray,
            overlay: UIColor.lightGray,
            dark: UIColor.darkGray
        )

        static var current: Palette {
            switch Theme.current {
            case .day: return dayPalette
            case .night: return nightPalette
            }
        }
    }

    enum Theme {
        static var current: Theme = .day {
            didSet { NotificationCenter.default.post(name: .themeDidChange, object: nil) }
        }
        case day
        case night
    }

    struct Configuration {
        static let EVENT_START_TIME = Date(timeIntervalSince1970: 1519423200) // 2018-02-23T16:00:00-0600 = 2018-02-23T22:00:00+0000
        static let HACKING_START_TIME = Date(timeIntervalSince1970: 1519455600) // 2018-02-23T23:00:00-0600 = 2018-02-24T07:00:00+0000
        static let HACKING_END_TIME = Date(timeIntervalSince1970: 1519578000) // 2018-02-25T11:00:00-0600 = 2018-02-25T17:00:00+0000
        static let EVENT_END_TIME = Date(timeIntervalSince1970: 1519599600) // 2018-02-25T17:00:00-0600 = 2018-02-25T23:00:00+0000

        static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1519365600) // 2018-02-23T00:00:00-0600 = 2018-02-23T06:00:00+0000
        static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1519451999) // 2018-02-23T23:59:59-0600 = 2018-02-24T05:59:59+0000
        static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1519452000) // 2018-02-24T00:00:00-0600 = 2018-02-24T06:00:00+0000
        static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1519538399) // 2018-02-24T23:59:59-0600 = 2018-02-25T05:59:59+0000
        static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1519538400) // 2018-02-25T00:00:00-0600 = 2018-02-25T06:00:00+0000
        static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1519624799) // 2018-02-25T23:59:59-0600 = 2018-02-26T05:59:59+0000
    }
}
