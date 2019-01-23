//
//  HIAPIUserToken.swift
//  HackIllinois
//
//  Created by Rishi Masand on 1/21/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

struct HIAPIUserToken: Codable, APIReturnable {
    var token: String
}
