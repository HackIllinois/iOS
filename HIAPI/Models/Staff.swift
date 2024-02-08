//
//  Staff.swift
//  HIAPI
//
//  Created by Dev Patel on 2/7/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
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

