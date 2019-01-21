//
//  HIAPIAnnouncement.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

struct HIAPIAnnouncement: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIAnnouncement>

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case time
        case topic
    }

    var title: String
    var body: String
    var time: Int64
    var topic: String
}
