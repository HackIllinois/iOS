//
//  Staff.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/7/24.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct StaffContainer: Decodable, APIReturnable {
    public let shifts: [Staff]
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        self.items = try container.decode([Staff].self)
//    }
}

public struct Staff: Codable {
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
    public let isPro: String
    public let eventId: String
    public let isStaff: Bool
    public let name: Int
    public let description: String
    public let startTime: Date
    public let endTime: Date
    public let eventType: String
    public let exp: Int
    public let locations: [Location]
    public let isAsync: Bool
    public let mapImageUrl: String
    public let points: Int
    public let isPrivate: Bool
    public let displayOnStaffCheckIn: Bool


}

public struct UserAttendanceContainer: Codable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
            case sucess
        }
        public let sucess: Bool
}

public struct StaffAttendanceContainer: Codable, APIReturnable {

}

