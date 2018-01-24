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

    class var headers: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers["Content-Type"] = "application/json"
        if let user = HIApplicationStateController.shared?.user {
            switch user.loginMethod {
            case .github:
                headers["Authorization"] = "Bearer \(user.token)"
            case .userPass:
                headers["Authorization"] = "Basic \(user.token)"
            }
        }
        return headers
    }
}
