//
//  CheckInEvent.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/30/20.
//  Copyright © 2020 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct CheckInContainer: Decodable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case idContainer = "data"
    }

    public let id: String
    public let idContainer: IDContainer
}

public struct IDContainer: Codable {
    public let id: String
}
