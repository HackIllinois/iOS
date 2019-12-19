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

final class HITimeDataSource {
    static var shared = HITimeDataSource()

    // Times set initially with constants as default values
    var eventStart: Date = HIConstants.EVENT_START_TIME
    var eventEnd: Date = HIConstants.EVENT_END_TIME
    var hackStart: Date = HIConstants.HACKING_START_TIME
    var hackEnd: Date = HIConstants.HACKING_END_TIME
    var fridayStart: Date = HIConstants.FRIDAY_START_TIME
    var fridayEnd: Date = HIConstants.FRIDAY_END_TIME
    var saturdayStart: Date = HIConstants.SATURDAY_START_TIME
    var saturdayEnd: Date = HIConstants.SATURDAY_END_TIME
    var sundayStart: Date = HIConstants.SUNDAY_START_TIME
    var sundayEnd: Date = HIConstants.SUNDAY_END_TIME

    private init() {
        _ = self.updateTimes()
    }

    //Returns whether times have been updated or not with syncronous api call to get times
    func updateTimes() -> Bool {
        var success: Bool = false
        let semaphore = DispatchSemaphore(value: 0)

        // Update the times of event
        TimeService.getTimes()
            .onCompletion { result in
                do {
                    let (timeContainer, _) = try result.get()
                    let apiEventTimes = timeContainer.eventTimes

                    self.eventStart = apiEventTimes.eventStart
                    self.eventEnd = apiEventTimes.eventEnd
                    self.hackStart = apiEventTimes.hackStart
                    self.hackEnd = apiEventTimes.hackEnd
                    self.fridayStart = apiEventTimes.fridayStart
                    self.fridayEnd = apiEventTimes.fridayEnd
                    self.saturdayStart = apiEventTimes.saturdayStart
                    self.saturdayEnd = apiEventTimes.saturdayEnd
                    self.sundayStart = apiEventTimes.sundayStart
                    self.sundayEnd = apiEventTimes.sundayEnd
                    success = true
                } catch {
                    self.setDefaultTimes()
                    print(error)
                }
                semaphore.signal()
            }
            .launch()

        //Syncronous API call to get times
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return success
    }

    func setDefaultTimes() {
        eventStart = HIConstants.EVENT_START_TIME
        eventEnd = HIConstants.EVENT_END_TIME
        hackStart = HIConstants.HACKING_START_TIME
        hackEnd = HIConstants.HACKING_END_TIME
        fridayStart = HIConstants.FRIDAY_START_TIME
        fridayEnd = HIConstants.FRIDAY_END_TIME
        saturdayStart = HIConstants.SATURDAY_START_TIME
        saturdayEnd = HIConstants.SATURDAY_END_TIME
        sundayStart = HIConstants.SUNDAY_START_TIME
        sundayEnd = HIConstants.SUNDAY_END_TIME
    }
}
