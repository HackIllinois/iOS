//
//  Announcement.swift
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

public struct Announcement: Codable {
    public typealias Contained = ReturnDataContainer<Announcement>

    internal enum CodingKeys: String, CodingKey {
        case id
        case title
        case info = "description"
        case time = "created"
    }

    public var id: Int16
    public var title: String
    public var info: String
    public var time: Date
}
