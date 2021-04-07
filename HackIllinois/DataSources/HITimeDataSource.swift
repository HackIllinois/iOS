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
        eventStart: Date(timeIntervalSince1970: 1618005600), // Friday, April 9, 2021 5:00:00 PM CST
        eventEnd: Date(timeIntervalSince1970: 1618268400), // Monday, April 12, 2021 6:00:00 PM CST
        hackStart: Date(timeIntervalSince1970: 1618009200), // Friday, April 9, 2021 6:00:00 PM CST
        hackEnd: Date(timeIntervalSince1970: 1618182000), // Sunday, April 11, 2021 6:00:00 PM CST
        fridayStart: Date(timeIntervalSince1970: 1617944400), // Friday, April 9, 2021 12:00:00 AM CST
        fridayEnd: Date(timeIntervalSince1970: 1618030799), // Friday, April 9, 2021 11:59:59 PM CST
        saturdayStart: Date(timeIntervalSince1970: 1618030800), // Saturday, April 10, 2021 12:00:00 AM CST
        saturdayEnd: Date(timeIntervalSince1970: 1618117199), // Saturday, April 10, 2021 11:59:59 PM CST
        sundayStart: Date(timeIntervalSince1970: 1618117200), // Sunday, April 11, 2021 12:00:00 AM CST
        sundayEnd: Date(timeIntervalSince1970: 1618203599), // Sunday, April 11, 2021 11:59:59 PM CST
        mondayStart: Date(timeIntervalSince1970: 1618203600), // Monday, April 12, 2021 12:00:00 AM CST
        mondayEnd: Date(timeIntervalSince1970: 1618289999) // Monday, April 12, 2021 11:59:59 PM CST
    )

    var eventTimes = HITimeDataSource.defaultTimes

    private init() {
        self.updateTimes()
    }

    ///Returns whether times have been updated or not with synchronous api call to get times
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
                        "Unable to update event times, setting default HackIllinois 2021 times: %s",
                        log: Logger.api,
                        type: .error,
                        String(describing: error)
                    )
                }
                semaphore.signal()
            }
            .launch()

        //Synchronous API call to get times
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
