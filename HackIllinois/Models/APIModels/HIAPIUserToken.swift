//
//  HIAPIUserToken.swift
//  HackIllinois
//
//  Created by Rishi Masand on 1/21/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

struct HIAPIUserToken: Codable, APIReturnable {
    var token: String
}
