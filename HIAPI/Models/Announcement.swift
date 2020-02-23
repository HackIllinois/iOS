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
        case topic
        case title
        case body
        case time
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
        let time = try container.decode(Double.self, forKey: .time)
        self.time = Date(timeIntervalSince1970: time)
    }

    public let topic: String
    public let title: String
    public let body: String
    public let time: Date
}
