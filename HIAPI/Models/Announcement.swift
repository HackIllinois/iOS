//
//  Announcement.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct AnnouncementContainer: Codable, APIReturnable {
    public let announcements: [Announcement]
}

public struct Announcement: Codable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case title
        case info = "description"
        case time = "created"
    }

    public let id: Int16
    public let title: String
    public let info: String
    public let time: Date
}
