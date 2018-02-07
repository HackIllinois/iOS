//
//  HIAPIAttendee.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/7/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

struct HIAPIAttendee: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIAttendee>

    let firstName: String
    let lastName: String
    let diet: HIDietaryRestrictions
}
