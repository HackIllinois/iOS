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

public struct AnnouncementContainer: Decodable, APIReturnable {

    internal enum CodingKeys: String, CodingKey {
        case announcements = "notifications"
    }

    public let announcements: [Announcement]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(AnnouncementContainer.self, from: data)
    }
}

public struct Announcement: Codable {
    internal enum CodingKeys: String, CodingKey {
        //case id
        case title
        case info = "body"
        case time
        case topicName //Attendee, Volunteer, Mentor
    }

    //public let id: Int16
    public let title: String
    public let info: String
    public let time: Date
    public let topicName: String
}
