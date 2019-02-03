//
//  TrackingService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class TrackingService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "/tracking"
    }

    override public static func hiValidate(statusCode: Int) throws {
        if !(200..<300).contains(statusCode) && statusCode != 400 {
            let description = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw APIRequestError.invalidHTTPReponse(code: statusCode, description: description)
        }
    }

    public static func track(id: Int) -> APIRequest<SuccessContainer> {
        return APIRequest<SuccessContainer>(service: self, endpoint: "/\(id)", method: .GET)
    }

    public static func create(name: String, duration: Int) -> APIRequest<SuccessContainer> {
        var eventDict = [String: Any]()
        eventDict["name"]     = name
        eventDict["duration"] = duration * 60 // user inputs minutes but API wants seconds
        return APIRequest<SuccessContainer>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

}
