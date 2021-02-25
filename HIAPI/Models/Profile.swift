//
//  Profile.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct Profile: Codable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case points
        case timezone
        case info = "Description"
        case discord
        case avatarUrl
        case teamStatus
        case interests
    }

    public let id: String
    public let firstName: String
    public let lastName: String
    public let points: Int
    public let timezone: String
    public let info: String
    public let discord: String
    public let avatarUrl: String
    public let teamStatus: String
    public let interests: [String]
}
