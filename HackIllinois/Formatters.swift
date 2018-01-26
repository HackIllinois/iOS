//
//  Formatters.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation

extension Formatter {

    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    static let iso8601withoutMS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()

    static let coreData: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        return formatter
    }()

    static let simpleTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

extension Date {
    static let YEAR_IN_SECONDS   = 31540000.0
    static let MONTH_IN_SECONDS  =  2628000.0
    static let WEEK_IN_SECONDS   =   604800.0
    static let DAY_IN_SECONDS    =    86400.0
    static let HOUR_IN_SECONDS   =     3600.0
    static let MINUTE_IN_SECONDS =       60.0
    static let SECOND_IN_SECONDS =        1.0

    static func humanReadableTimeSince(_ date: Date) -> String {
        let timeSinceDate = Date().timeIntervalSince(date)

        switch timeSinceDate {
        // YEARS
        case (2 * YEAR_IN_SECONDS)... :
            let years = Int(floor(timeSinceDate/YEAR_IN_SECONDS))
            return "\(years) years ago"
        case (1 * YEAR_IN_SECONDS)... :
            return "last year"

        // MONTH
        case (2 * MONTH_IN_SECONDS)... :
            let month = Int(floor(timeSinceDate/MONTH_IN_SECONDS))
            return "\(month) months ago"
        case (1 * MONTH_IN_SECONDS)... :
            return "last month"

        // WEEK
        case (2 * WEEK_IN_SECONDS)... :
            let week = Int(floor(timeSinceDate/WEEK_IN_SECONDS))
            return "\(week) weeks ago"
        case (1 * WEEK_IN_SECONDS)... :
            return "last week"

        // DAY
        case (2 * DAY_IN_SECONDS)... :
            let day = Int(floor(timeSinceDate/DAY_IN_SECONDS))
            return "\(day) days ago"
        case (1 * DAY_IN_SECONDS)... :
            return "yesterday"

        // HOUR
        case (2 * HOUR_IN_SECONDS)... :
            let hour = Int(floor(timeSinceDate/HOUR_IN_SECONDS))
            return "\(hour) hours ago"
        case (1 * HOUR_IN_SECONDS)... :
            return "yesterday"

        // MINUTE
        case (2 * MINUTE_IN_SECONDS)... :
            let minute = Int(floor(timeSinceDate/MINUTE_IN_SECONDS))
            return "\(minute) minutes ago"
        case (1 * MINUTE_IN_SECONDS)... :
            return "a minute ago"

        // SECOND
        case (15 * SECOND_IN_SECONDS)... :
            return "a few seconds ago"

        default:
            return "just now"
        }

    }
}

extension Date {
    func byRemoving(components componentsToRemove: Set<Calendar.Component>) -> Date {
        let allComponents: Set<Calendar.Component> = [
            .calendar,
            .day,
            .era,
            .hour,
            .minute,
            .month,
            .nanosecond,
            .quarter,
            .second,
            .timeZone,
            .weekOfMonth,
            .weekOfYear,
            .weekday,
            .weekdayOrdinal,
            .year,
            .yearForWeekOfYear
        ]
        let remainingComponents = allComponents.symmetricDifference(componentsToRemove)
        let extractedComponents = Calendar.current.dateComponents(remainingComponents, from: self)
        return Calendar.current.date(from: extractedComponents)!
    }
}
