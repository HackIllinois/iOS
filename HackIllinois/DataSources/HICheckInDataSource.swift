//
//  HICheckInDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/30/20.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import HIAPI
import os

final class HICheckInDataSource {
    static var shared = HICheckInDataSource()

    var checkInID: String?

    private init() {
        
    }

    func updateCheckInID() {
        let semaphore = DispatchSemaphore(value: 0)

        // Update the times of event syncronously
        CheckInEventService.getCheckInID()
            .onCompletion { result in
                do {
                    let (checkInContainer, _) = try result.get()
                    self.checkInID = checkInContainer.idContainer.id
                } catch {
                    os_log(
                        "Unable to update check in id: %s",
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
