//
//  HIBaseService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import APIManager

class HIBaseService: APIService {
    class var baseURL: String {
        return "https://api.hackillinois.org/"
    }

    static var headers = ["Content-Type": "application/json"]

    static var paramaters = ["client": "iOS"]

    static func validate(statusCode: Int) throws {
        try hiValidate(statusCode: statusCode)
    }

    class func hiValidate(statusCode: Int) throws {
        if !(200..<300).contains(statusCode) {
            let description = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw APIRequestError.invalidHTTPReponse(code: statusCode, description: description)
        }
    }
}
