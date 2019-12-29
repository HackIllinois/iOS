//
//  Event.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct EventContainer: Decodable, APIReturnable {
    public let events: [Event]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(EventContainer.self, from: data)
    }
}

public struct Event: Codable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case endTime
        case eventType
        case info = "description"
        case locations
        case name
        case sponsor
        case startTime
    }

    public let id: String
    public let endTime: Date
    // Could be made into an enum with some coredata work
    public let eventType: String
    public let info: String
    public let locations: [Location]
    public let name: String
    public let sponsor: String
    public let startTime: Date
}

public struct Location: Codable {
    internal enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case name = "description"
    }

    public let latitude: Double
    public let longitude: Double
    public let name: String
}

public struct Favorite: Codable, APIReturnable {
    public let events: Set<String>
    public let id: String
}
