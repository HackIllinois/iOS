//
//  SuccessContainer.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/28/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct SuccessContainer: Decodable, APIReturnable {
    public let meta: String?
    public let error: Error?

    public struct Error: Decodable {
        public let type: String
        public let status: Int
        public let title: String
        public let message: String
        public let source: String
    }
}
