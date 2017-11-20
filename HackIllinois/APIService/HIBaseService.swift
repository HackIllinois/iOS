//
//  HIBaseService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIBaseService: APIService {

    class var baseURL: String {
        return "http://ec2-107-20-14-41.compute-1.amazonaws.com/v1"
    }

    class var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "Authorization": HIBaseService.authorizationKey
        ]
    }

    static var authorizationKey = ""




}
