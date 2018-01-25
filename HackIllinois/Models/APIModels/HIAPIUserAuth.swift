//
//  HIUserAuth.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/17/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

struct HIAPIUserAuth: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIUserAuth>

    var auth: String
}
