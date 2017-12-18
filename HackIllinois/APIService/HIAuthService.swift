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

    class func login(email: String, password: String) -> APIRequest<HIAuthService, Data> {
        var body = [String: String]()
        body["email"]    = email
        body["password"] = password
        return APIRequest<HIAuthService, Data>(endpoint: "", body: body, method: .POST)
    }

//    class func loginSession() -> SFAuthenticationSession? {
//        guard let url = URL(string: baseURL) else { return nil }
//        return session
//    }

}
