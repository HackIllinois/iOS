//
//  HIAPITracking.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import UIKit

struct HIAPITracking: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPITracking>
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        case created
        case count
    }
    var id: Int16
    var name: String
    var duration: Int16
    var created: String
    var count: Int16
}
