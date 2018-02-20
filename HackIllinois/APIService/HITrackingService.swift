//
//  HITrackingService.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

final class HITrackingService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/tracking"
    }

    override static func hiValidate(statusCode: Int) throws {
        if !(200..<300).contains(statusCode) && statusCode != 400 {
            let description = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw APIRequestError.invalidHTTPReponse(code: statusCode, description: description)
        }
    }

    static func track(id: Int) -> APIRequest<HIAPISuccessContainer> {
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "/\(id)", method: .GET)
    }

    static func create(name: String, duration: Int) -> APIRequest<HIAPISuccessContainer> {
        var eventDict = [String: Any]()
        eventDict["name"]     = name
        eventDict["duration"] = duration * 60 // user inputs minutes but API wants seconds
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

}
