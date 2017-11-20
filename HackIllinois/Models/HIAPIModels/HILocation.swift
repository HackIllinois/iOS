//
//  HILocation.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation

typealias HILocationContained  = HIAPIReturnDataContainer<HILocation>
typealias HILocationsContained = HIAPIReturnDataContainer<[HILocation]>

struct HILocation: Decodable {
    var id: Int16
    var latitude: Double
    var longitude: Double
    var name: String
}
