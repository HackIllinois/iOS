//
//  HIUserService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

final class HIUserService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/user"
    }

    static func get() -> APIRequest<HIAPIUser.Contained> {
        return APIRequest<HIAPIUser.Contained>(service: self, endpoint: "", method: .GET)
    }
}
