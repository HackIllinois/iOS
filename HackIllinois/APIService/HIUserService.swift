//
//  HIUserService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIUserService: HIBaseService {
    override class var baseURL: String {
        return super.baseURL + "/user"
    }

    class func get() -> APIRequest<HIAPIUser.Contained> {
        return APIRequest<HIAPIUser.Contained>(service: self, endpoint: "", method: .GET)
    }
}
