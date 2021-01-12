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

    public static let defaultTimes = EventTimes(
        twoWeeksBeforeStart: Date(timeIntervalSince1970: 1610587800), // Wednesday, Jan 13, 2021 7:30 PM GMT-06:00 FOR TESTING
        oneWeekBeforeStart: Date(timeIntervalSince1970: 1611192600), // Wednesday, Jan 18, 2021 7:30 PM GMT-06:00 FOR TESTING
        eventStart: Date(timeIntervalSince1970: 1582927200), // Friday, February 28, 2020 4:00:00 PM GMT-06:00
        eventEnd: Date(timeIntervalSince1970: 1583103600), // Sunday, March 1, 2020 05:00:00 PM GMT-06:00
        hackStart: Date(timeIntervalSince1970: 1582952400), // Friday, February 28, 2020 11:00:00 PM
        hackEnd: Date(timeIntervalSince1970: 1583078400), // Sunday, March 1, 2020 10:00:00 AM GMT-06:00
        fridayStart: Date(timeIntervalSince1970: 1582869600), // Friday, February 28, 2020 12:00:00 AM
        fridayEnd: Date(timeIntervalSince1970: 1582955999), // Friday, February 28, 2020 11:59:59 PM GMT-06:00
        saturdayStart: Date(timeIntervalSince1970: 1582956000), // Saturday, February 29, 2020 12:00:00 AM
        saturdayEnd: Date(timeIntervalSince1970: 1583042399), // Saturday, February 29, 2020 11:59:59 PM
        sundayStart: Date(timeIntervalSince1970: 1583042400), // Sunday, March 1, 2020 12:00:00 AM GMT-06:00
        sundayEnd: Date(timeIntervalSince1970: 1583128799) // Sunday, March 1, 2020 11:59:59 PM GMT-06:006:00
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
                    os_log(
                        "Unable to update event times, setting default HackIllinois 2020 times: %s",
                        log: Logger.api,
                        type: .error,
                        String(describing: error)
                    )
                }
                semaphore.signal()
            }
            .launch()

        //Syncronous API call to get times
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
