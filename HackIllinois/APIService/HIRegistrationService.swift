//
//  HIRegistrationService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/7/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

final class HIRegistrationService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/registration"
    }

    static func getAttendee(by token: String, with loginMethod: HILoginMethod) -> APIRequest<HIAPIAttendee.Contained> {
        var headers = HTTPHeaders()
        switch loginMethod {
        case .github:
            headers["Authorization"] = "Bearer \(token)"
        case .userPass:
            headers["Authorization"] = "Basic \(token)"
        }
        return APIRequest<HIAPIAttendee.Contained>(service: self, endpoint: "/attendee", headers: headers, method: .GET)
    }
}
