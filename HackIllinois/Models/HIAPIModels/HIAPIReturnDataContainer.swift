//
//  HIAPIReturnDataContainer.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

struct HIAPIReturnDataContainer<Model: Decodable>: Decodable, APIReturnable {
    var meta: String?
    var data: [Model]
}
