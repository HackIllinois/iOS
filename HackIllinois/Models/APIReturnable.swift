//
//  APIReturnable.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

extension Data: APIReturnable {
    public init(from: Data) throws {
        self = from
    }
}
