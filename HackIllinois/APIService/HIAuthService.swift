//
//  HIAuthService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIAuthService: HIBaseService {

    override class var baseURL: String {
        return super.baseURL + "/auth"
    }

//    class func login() -> APIRequest<HIAuthService, Data> {
//        return APIRequest<HIAuthService, Data>(endpoint: "", method: .GET)
//    }


}
