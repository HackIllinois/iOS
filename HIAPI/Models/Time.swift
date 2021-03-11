//
//  Time.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/27/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct TimeContainer: Decodable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case eventTimes = "data"
    }

    public let id: String
    public let eventTimes: EventTimes

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(TimeContainer.self, from: data)
    }
}

public struct EventTimes: Codable {
    public let eventStart: Date
    public let eventEnd: Date
    public let hackStart: Date
    public let hackEnd: Date
    public let fridayStart: Date
    public let fridayEnd: Date
    public let saturdayStart: Date
    public let saturdayEnd: Date
    public let sundayStart: Date
    public let sundayEnd: Date
    public let mondayStart: Date
    public let mondayEnd: Date

    public init(eventStart: Date, eventEnd: Date, hackStart: Date, hackEnd: Date, fridayStart: Date, fridayEnd: Date,
                saturdayStart: Date, saturdayEnd: Date, sundayStart: Date, sundayEnd: Date, mondayStart: Date, mondayEnd: Date) {
        self.eventStart = eventStart
        self.eventEnd = eventEnd
        self.hackStart = hackStart
        self.hackEnd = hackEnd
        self.fridayStart = fridayStart
        self.fridayEnd = fridayEnd
        self.saturdayStart = saturdayStart
        self.saturdayEnd = saturdayEnd
        self.sundayStart = sundayStart
        self.sundayEnd = sundayEnd
        self.mondayStart = mondayStart
        self.mondayEnd = mondayEnd
    }
}
