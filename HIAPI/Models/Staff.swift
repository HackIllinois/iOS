//
//  Event.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/04/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct ShiftContainer: Decodable, APIReturnable {
    public let shifts: [Shift]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(ShiftContainer.self, from: data)
    }
}

public struct Shift: Codable {
    internal enum CodingKeys: String, CodingKey {
        case isPro
        case eventId
        case isStaff
        case name
        case description
        case startTime
        case endTime
        case eventType
        case exp
        case locations
        case isAsync
        case mapImageUrl
        case points
        case isPrivate
        case displayOnStaffCheckIn
    }

    public let isPro: Bool
    public let eventId: String
    public let isStaff: String
    public let name: String
    public let description: String
    public let startTime: Int
    public let endTime: Int
    public let eventType: String
    public let exp: Int
    public let locations: [ShiftLocation]
    public let isAsync: Bool
    public let mapImageUrl: String?
    public let points: String?
    public let isPrivate: Bool
    public let displayOnStaffCheckIn: Bool
}

public struct ShiftLocation: Codable {
    internal enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case name = "description"
    }

    public let latitude: Double
    public let longitude: Double
    public let name: String
}
