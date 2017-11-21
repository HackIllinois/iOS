//
//  HIEvent.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation

typealias HIEventContained = HIAPIReturnDataContainer<HIEvent>

struct HIEvent: Decodable {
    var end: Date
    var id: Int16
    var info: String
    var locations: [HILiteLocation]
    var name: String
    var start: Date
    var stringTag: String
    var tag: Int16 {
        return (stringTag == "PRE_EVENT") ? 0 : 1
    }

    private enum CodingKeys: String, CodingKey {
        case end = "endTime"
        case id
        case info = "description"
        case locations
        case name
        case start = "startTime"
        case stringTag = "tag"
    }
}

struct HILiteLocation: Decodable {
    var id: Int16

    enum CodingKeys: String, CodingKey {
        case id = "locationId"
    }
}

