//
//  Project.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/20/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct ProjectContainer: Decodable, APIReturnable {
    public let projects: [Project]
}

public struct Project: Codable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case mentors
        case room
        case tags
        case number
    }

    public let id: String
    public let name: String
    public let info: String
    public let mentors: [String]
    public let room: String
    public let tags: [String]
    public let number: Int32
}

public struct ProjectFavorites: Codable, APIReturnable {
    public let projects: Set<String>
    public let id: String
}
