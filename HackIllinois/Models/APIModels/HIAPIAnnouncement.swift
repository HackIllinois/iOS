//
//  HIAPIAnnouncement.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

struct HIAPIAnnouncement: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIAnnouncement>

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case info = "description"
        case time = "created"
    }

    var id: Int16
    var title: String
    var info: String
    var time: Date
}
