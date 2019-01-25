//
//  Event.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

public struct Event: Codable {
    public typealias Contained = ReturnDataContainer<Event>

    internal enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case end = "endTime"
        case start = "startTime"
        case locations
    }

    public var favorite = false
    public let id: Int16
    public let name: String
    public let info: String
    public let end: Date
    public let start: Date
    public let locations: [LocationReference]

    public struct LocationReference: Codable {
        public let id: Int16
        public let eventId: Int16
        public let locationId: Int16
    }
}

public struct Location: Codable {
    public typealias Contained = ReturnDataContainer<Location>

    public let id: Int16
    public let name: String
    public let longitude: Double
    public let latitude: Double
}

public struct Favorite: Codable {
    public typealias Contained = ReturnDataContainer<Favorite>

    public let id: Int16
    public let userId: Int16
    public let eventId: Int16
}
