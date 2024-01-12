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
        checkInStart: Date(timeIntervalSince1970: 1708723800), // Friday, February 23, 2024 3:30:00 PM CST
        checkInEnd: Date(timeIntervalSince1970: 1708725600), // Friday, February 23, 2024 4:00:00 PM CST
        scavengerHuntStart: Date(timeIntervalSince1970: 1708725600), // Friday, February 23, 2024 4:00:00 PM CST
        scavengerHuntEnd: Date(timeIntervalSince1970: 1708732800), // Friday, February 23, 2024 6:00:00 PM CST
        openingCeremonyStart: Date(timeIntervalSince1970: 1708732800), // Friday, February 23, 2024 6:00:00 PM CST
        openingCeremonyEnd: Date(timeIntervalSince1970: 1708736400), // Friday, February 23, 2024 7:00:00 PM CST
        projectShowcaseStart: Date(timeIntervalSince1970: 1708880400), // Sunday, February 25, 2024 11:00:00 AM CST
        projectShowcaseEnd: Date(timeIntervalSince1970: 1708894800), // Sunday, February 25, 2024 3:00:00 PM CST
        closingCeremonyStart: Date(timeIntervalSince1970: 1708894800), // Sunday, February 25, 2024 3:00:00 PM CST
        closingCeremonyEnd: Date(timeIntervalSince1970: 1708898400), // Sunday, February 25, 2024 4:00:00 PM CST
        
        eventStart: Date(timeIntervalSince1970: 1708732800), // Friday, February 23, 2024 6:00:00 PM CST
        eventEnd: Date(timeIntervalSince1970: 1708898400), // Sunday, February 25, 2024 4:00:00 PM CST
        hackStart: Date(timeIntervalSince1970: 1708736400), // Friday, February 23, 2024 7:00:00 PM CST
        hackEnd: Date(timeIntervalSince1970: 1708876800), // Sunday, February 25, 2024 10:00:00 AM CST
        fridayStart: Date(timeIntervalSince1970: 1708668000), // Friday, February 23, 2024 12:00:00 AM CST
        fridayEnd: Date(timeIntervalSince1970: 1708754399), // Friday, February 23, 2024 11:59:59 PM CST
        saturdayStart: Date(timeIntervalSince1970: 1708754400), // Saturday, February 24, 2024 12:00:00 AM CST
        saturdayEnd: Date(timeIntervalSince1970: 1708840799), // Saturday, February 24, 2024 11:59:59 PM CST
        sundayStart: Date(timeIntervalSince1970: 1708840800), // Sunday, February 25, 2024 12:00:00 AM CST
        sundayEnd: Date(timeIntervalSince1970: 1708927199) // Sunday, February 25, 2024 11:59:59 PM CST
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
