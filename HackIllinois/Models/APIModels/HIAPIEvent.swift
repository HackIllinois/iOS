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

struct HIAPIEventReturnDataContainer<Model: Decodable>: Decodable, APIReturnable {
    var events: [Model]

    enum CodingKeys: CodingKey {
        case events
    }

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
        self = try decoder.decode(HIAPIEventReturnDataContainer.self, from: data)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            events = try container.decode([Model].self, forKey: .events)
        } catch _ {
            let singleDataValue = try container.decode(Model.self, forKey: .events)
            events = [singleDataValue]
        }
    }
}

struct HIAPIEventsContainer: Codable {

    let events: [HIAPIEventDated]

    private enum CodingKeys: String, CodingKey {
        case events
    }

}

struct HIAPIEvent {

    var favorite = false
    var name: String
    var info: String
    var end: Date
    var start: Date
    var eventType: String
    var sponsor: String
    var latitude: Double
    var longitude: Double

    init(favorite: Bool, name: String, info: String, end: Date, start: Date, eventType: String, sponsor: String, latitude: Double, longitude: Double) {
        self.favorite = favorite
        self.name = name
        self.info = info
        self.end = end
        self.start = start
        self.eventType = eventType
        self.sponsor = sponsor
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct HIAPIEventDated: Codable {
    typealias Contained = HIAPIEventReturnDataContainer<HIAPIEventDated>

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
    var end: Double
    var start: Double
    var eventType: String
    var locationDescription: String
    var sponsor: String
    var latitude: Double
    var longitude: Double
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
