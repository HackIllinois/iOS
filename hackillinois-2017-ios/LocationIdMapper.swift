//
//  LocationIdMapper.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/22.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import Foundation

class LocationIdMapper {
    static var locationMappings: [String: Int] = [
        "DCL": 1,
        "Digital Computer Laboratory": 1,
        "Thomas M. Siebel Center": 2,
        "Siebel": 2,
        "Thomas Siebel Center": 2,
        "ECEB": 3,
        "Electrical Computer Engineering Building": 3,
        "Union": 4,
        "Illini Union": 4,
        "Kenny Gym": 5,
        "Kenneth Gym": 5,
        "Kenny Gym Annex": 5
    ]
    
    static func getLocalId(fromShortname: String) -> Int {
        let id = locationMappings[fromShortname]
        return id == nil ? -1 : id!
    }
}
