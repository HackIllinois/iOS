//
//  Constants.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/24/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI

// MARK: - Constants
class HIConstants {

    static var shared = HIConstants()

    //Returns whether times have been updated or not
    func updateTimes() -> Bool {
        print("Entering update times")
        var success: Bool = false
        var updated: Bool = false
        // Update the times of event
        TimeService.getTimes()
            .onCompletion { result in
                do {
                    let (timeContainer, _) = try result.get()
                    let apiEventTimes = timeContainer.eventTimes

                    HIConstants.EVENT_START_TIME = apiEventTimes.eventStart
                    HIConstants.EVENT_END_TIME = apiEventTimes.eventEnd
                    HIConstants.HACKING_START_TIME = apiEventTimes.hackStart
                    HIConstants.HACKING_END_TIME = apiEventTimes.hackEnd
                    HIConstants.FRIDAY_START_TIME = apiEventTimes.fridayStart
                    HIConstants.FRIDAY_END_TIME = apiEventTimes.fridayEnd
                    HIConstants.SATURDAY_START_TIME = apiEventTimes.saturdayStart
                    HIConstants.SATURDAY_END_TIME = apiEventTimes.saturdayEnd
                    HIConstants.SUNDAY_START_TIME = apiEventTimes.sundayStart
                    HIConstants.SUNDAY_END_TIME = apiEventTimes.sundayEnd
                    print("HIconst updated::")
                    print(apiEventTimes.eventStart)
                    updated = true
                    success = true
                } catch {
                    print(error)
                    updated = true
                }
            }
            .launch()
        
        //Not sure how to make API sync instead of async
        while(!updated) { }
        
        return success
    }

    static var EVENT_START_TIME = Date(timeIntervalSince1970: 1550872800) // Friday, February 22, 2019 4:00:00 PM GMT-06:00
    static var HACKING_START_TIME = Date(timeIntervalSince1970: 1550898000) // Friday, February 22, 2019 11:00:00 PM GMT-06:00
    static var HACKING_END_TIME = Date(timeIntervalSince1970: 1551024000) // Sunday, February 24, 2019 10:00:00 AM GMT-06:00
    static var EVENT_END_TIME = Date(timeIntervalSince1970: 1551049200) // Sunday, February 24, 2019 05:00:00 PM GMT-06:00
    static var FRIDAY_START_TIME = Date(timeIntervalSince1970: 1550815200) // Friday, February 22, 2019 12:00:00 AM GMT-06:00
    static var FRIDAY_END_TIME = Date(timeIntervalSince1970: 1550901599) // Friday, February 22, 2019 11:59:59 PM GMT-06:00
    static var SATURDAY_START_TIME = Date(timeIntervalSince1970: 1550901600) // Saturday, February 23, 2019 12:00:00 AM GMT-06:00
    static var SATURDAY_END_TIME = Date(timeIntervalSince1970: 1550987999) // Saturday, February 23, 2019 11:59:59 PM GMT-06:00
    static var SUNDAY_START_TIME = Date(timeIntervalSince1970: 1550988000) // Sunday, February 24, 2019 12:00:00 AM GMT-06:00
    static var SUNDAY_END_TIME = Date(timeIntervalSince1970: 1551074399) // Sunday, February 24, 2019 11:59:59 PM GMT-06:00
    
    // Times
//    static var EVENT_START_TIME = Date(timeIntervalSince1970: 1582927200) // Friday, February 28, 2020 1550872800 4:00:00 PM GMT-06:00
//    static var HACKING_START_TIME = Date(timeIntervalSince1970: 1582952400) // Friday, February 28, 2020 11:00:00 PM GMT-06:00
//    static var HACKING_END_TIME = Date(timeIntervalSince1970: 1583078400) // Sunday, March 1, 2020 10:00:00 AM GMT-06:00
//    static var EVENT_END_TIME = Date(timeIntervalSince1970: 1583103600) // Sunday, March 1, 2020 05:00:00 PM GMT-06:00
//
//    static var FRIDAY_START_TIME = Date(timeIntervalSince1970: 1582869600) // Friday, February 28, 2020 12:00:00 AM GMT-06:00
//    static var FRIDAY_END_TIME = Date(timeIntervalSince1970: 1582955999) // Friday, February 28, 2020 11:59:59 PM GMT-06:00
//    static var SATURDAY_START_TIME = Date(timeIntervalSince1970: 1582956000) // Saturday, February 29, 2020 12:00:00 AM GMT-06:00
//    static var SATURDAY_END_TIME = Date(timeIntervalSince1970: 1583042399) // Saturday, February 29, 2020 11:59:59 PM GMT-06:00
//    static var SUNDAY_START_TIME = Date(timeIntervalSince1970: 1583042400) // Sunday, March 1, 2020 12:00:00 AM GMT-06:00
//    static var SUNDAY_END_TIME = Date(timeIntervalSince1970: 1583128799) // Sunday, March 1, 2020 11:59:59 PM GMT-06:006:00

    // Keys
    static let STORED_ACCOUNT_KEY = "org.hackillinois.ios.active_account"
    static let APPLICATION_INSTALLED_KEY = "org.hackillinois.ios.application_installed"
    static func PASS_PROMPTED_KEY(user: HIUser) -> String {
        return "org.hackillinois.ios.pass_prompted_\(user.id)"
    }
}
