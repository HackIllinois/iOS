//
//  HIBaseService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import APIManager

class HIBaseService: APIService {
    class var baseURL: String {
        return "http://api.test.hackillinois.org/v1"
    }

    static var headers = ["Content-Type": "application/json"]
}
