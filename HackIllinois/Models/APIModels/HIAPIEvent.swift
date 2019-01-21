//
//  HIAPIEvent.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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

    var favorite = false
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

struct HIAPIFavorite: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIFavorite>

    var id: Int16
    var userId: Int16
    var eventId: Int16
}
