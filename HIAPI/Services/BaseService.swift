//
//  BaseService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public class BaseService: APIService {
    public class var baseURL: String {
        return "https://api.hackillinois.org/"
    }

    public static var headers: HTTPHeaders? = ["Content-Type": "application/json"]

    public static func validate(statusCode: Int) throws {
        try hiValidate(statusCode: statusCode)
    }

    internal class func hiValidate(statusCode: Int) throws {
        if statusCode != 200 {
            let description = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw APIRequestError.invalidHTTPReponse(code: statusCode, description: description)
        }
    }
}
