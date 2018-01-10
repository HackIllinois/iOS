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

    class func login(email: String?, password: String) -> APIRequest<Data> {
        var body = [String: String]()
        body["email"]    = email
        body["password"] = password
        return APIRequest<Data>(service: self, endpoint: "", body: body, method: .POST)
    }

    // let url = URL(string: "https://github.com/login/oauth/authorize?scope=user:email&client_id=6a31db63429227214035&redirect_uri=https://hackillinois.org/auth/ios")!
    class func githubLoginURL() -> URL {
        guard let url = URL(string: baseURL + "?mobile=1") else {
            fatalError()
        }
        return url
    }

}
