//
//  Time.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/27/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct Times: Codable, APIReturnable {
    public let id: String
    public let data: [String: Date]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(Times.self, from: data)
    }
}
