//
//  Interest.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/5/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct InterestContainer: Decodable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case options = "data"
    }

    public let id: String
    public let options: [String]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(InterestContainer.self, from: data)
    }
}
