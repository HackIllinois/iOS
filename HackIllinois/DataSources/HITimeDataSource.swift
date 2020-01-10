//
//  HITimeDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/18/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import HIAPI
import os

final class HITimeDataSource {
    static var shared = HITimeDataSource()

    // Event Times
    static let EVENT_START_TIME = Date(timeIntervalSince1970: 1582927200) // Friday, February 28, 2020 4:00:00 PM GMT-06:00
    static let HACKING_START_TIME = Date(timeIntervalSince1970: 1582952400) // Friday, February 28, 2020 11:00:00 PM GMT-06:00
    static let HACKING_END_TIME = Date(timeIntervalSince1970: 1583078400) // Sunday, March 1, 2020 10:00:00 AM GMT-06:00
    static let EVENT_END_TIME = Date(timeIntervalSince1970: 1583103600) // Sunday, March 1, 2020 05:00:00 PM GMT-06:00

    static let FRIDAY_START_TIME = Date(timeIntervalSince1970: 1582869600) // Friday, February 28, 2020 12:00:00 AM GMT-06:00
    static let FRIDAY_END_TIME = Date(timeIntervalSince1970: 1582955999) // Friday, February 28, 2020 11:59:59 PM GMT-06:00
    static let SATURDAY_START_TIME = Date(timeIntervalSince1970: 1582956000) // Saturday, February 29, 2020 12:00:00 AM GMT-06:00
    static let SATURDAY_END_TIME = Date(timeIntervalSince1970: 1583042399) // Saturday, February 29, 2020 11:59:59 PM GMT-06:00
    static let SUNDAY_START_TIME = Date(timeIntervalSince1970: 1583042400) // Sunday, March 1, 2020 12:00:00 AM GMT-06:00
    static let SUNDAY_END_TIME = Date(timeIntervalSince1970: 1583128799) // Sunday, March 1, 2020 11:59:59 PM GMT-06:006:00

    public static let defaultTimes = EventTimes(
        eventStart: HITimeDataSource.EVENT_START_TIME,
        eventEnd: HITimeDataSource.EVENT_END_TIME,
        hackStart: HITimeDataSource.HACKING_START_TIME,
        hackEnd: HITimeDataSource.HACKING_END_TIME,
        fridayStart: HITimeDataSource.FRIDAY_START_TIME,
        fridayEnd: HITimeDataSource.FRIDAY_END_TIME,
        saturdayStart: HITimeDataSource.SATURDAY_START_TIME,
        saturdayEnd: HITimeDataSource.SATURDAY_END_TIME,
        sundayStart: HITimeDataSource.SUNDAY_START_TIME,
        sundayEnd: HITimeDataSource.SUNDAY_END_TIME
    )

    var eventTimes = HITimeDataSource.defaultTimes

    private init() {
        self.updateTimes()
    }

    ///Returns whether times have been updated or not with syncronous api call to get times
    func updateTimes() {
        let semaphore = DispatchSemaphore(value: 0)

        // Update the times of event
        TimeService.getTimes()
            .onCompletion { result in
                do {
                    let (timeContainer, _) = try result.get()
                    self.eventTimes = timeContainer.eventTimes
                } catch {
                    self.eventTimes = HITimeDataSource.defaultTimes
                    os_log(
                        "%s",
                        log: Logger.api,
                        type: .error,
                        error.localizedDescription
                    )
                }
                semaphore.signal()
            }
            .launch()

        //Syncronous API call to get times
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
