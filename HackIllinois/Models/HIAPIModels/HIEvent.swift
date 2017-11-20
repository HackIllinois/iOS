//
//  HIEvent.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation

typealias HIEventContained = HIAPIReturnDataContainer<HIEvent>

struct HIEvent: Decodable {
    var id: Int
    var name: String
    var info: String
    var start: Date
    var end: Date
    var tag: Int
    var locations: [HILocation]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case start = "startTime"
        case end = "endTime"
        case tag
        case locations
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        info = try container.decode(String.self, forKey: .info)
//        start = try container.decode(Date.self, forKey: .start)
//        end = try container.decode(Date.self, forKey: .end)
//        tag = try container.decode(Int.self, forKey: .tag)
//        locations = try container.decode([HILocation].self, forKey: .locations)
//    }
}
