//
//  HIAPIEvent.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

struct HIAPIEvent: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIEvent>

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case end = "endTime"
        case start = "startTime"
        case locations
    }

    var id: Int16
    var name: String
    var info: String
    var end: Date
    var start: Date
    var locations: [HIAPILocationReference]

    struct HIAPILocationReference: Codable {
        var id: Int16
        var eventId: Int16
        var locationId: Int16
    }
}

struct HIAPILocation: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPILocation>

    var id: Int16
    var name: String
    var longitude: Double
    var latitude: Double
}
