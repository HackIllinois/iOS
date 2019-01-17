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
import APIManager

struct HIAPIEventsContainer: Decodable, APIReturnable {
    let events: [HIAPIEvent]
}

struct HIAPIEvent: Codable, APIReturnable {
    typealias Contained = HIAPIEventsContainer

    private enum CodingKeys: String, CodingKey {
        case name
        case info = "description"
        case end = "endTime"
        case start = "startTime"
        case eventType
        case latitude
        case longitude
        case locationDescription
        case sponsor
    }

    var favorite = false
    var name: String
    var info: String
    var end: Date
    var start: Date
    var eventType: String
    var locationDescription: String
    var sponsor: String
    var latitude: Double
    var longitude: Double

    init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(HIAPIEvent.self, from: data)
    }
}

struct HIAPILocation: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPILocation>

    var id: Int16
    var name: String
    var longitude: Double
    var latitude: Double
}

struct HIAPIFavorite: Codable, APIReturnable {
    let events: [String]
    let id: String
}
