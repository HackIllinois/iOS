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
        "Kenny Gym Annex": 5
    ]
    
    static var addressMappings: [Int16: String] = [
        1 : "1304 W Springfield Ave, Urbana, IL 61801",
        2 : "201 N Goodwin Ave, Urbana, IL 61801",
        3 : "306 N Wright St, Urbana, IL 61801",
        4 : "1401 W Green St, Urbana, IL 61801",
        5 : "1402-1406 W. Springfield Ave, Urbana, IL 61801"
    ]
    
    static func getLocalId(fromShortname: String) -> Int {
        let id = locationMappings[fromShortname]
        return id == nil ? -1 : id!
    }
    
}
