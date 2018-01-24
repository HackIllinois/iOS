//
//  HIAuthService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager
import SafariServices

class HIAuthService: HIBaseService {

    override class var baseURL: String {
        return super.baseURL + "/auth"
    }

    class func login(email: String, password: String) -> APIRequest<HIAPIUserAuth.Contained> {
        var body = [String: String]()
        body["email"]    = email
        body["password"] = password
        return APIRequest<HIAPIUserAuth.Contained>(service: self, endpoint: "", body: body, method: .POST)
    }

    class func githubLoginURL() -> URL {
        guard let url = URL(string: baseURL + "?isMobile=1") else {
            fatalError()
        }
        return url
    }

}
