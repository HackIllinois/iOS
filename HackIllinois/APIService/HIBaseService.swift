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

    static var paramaters = ["client" : "iOS"]

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
