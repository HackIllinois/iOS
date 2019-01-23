//
//  HIAuthService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager
import SafariServices

final class HIAuthService: HIBaseService {

    override static var baseURL: String {
        return super.baseURL + "/auth"
    }

    static func login(email: String, password: String) -> APIRequest<HIAPIUserAuth.Contained> {
        var body = [String: String]()
        body["email"]    = email
        body["password"] = password
        return APIRequest<HIAPIUserAuth.Contained>(service: self, endpoint: "", body: body, method: .POST)
    }

    static func githubLoginURL() -> URL {
        guard let url = URL(string: baseURL + "/github/?redirect_uri=https://test.hackillinois.org/auth/?isiOS=1") else { fatalError() }
        return url
    }

    static func oauthCallbackURL() -> URL {
        guard let url = URL(string: "https://test.hackillinois.org/auth/?isiOS=1") else { fatalError() }
        return url
    }

    static func getUserTokenFromCode(code: String) -> APIRequest<HIAPIUserToken> {
        var body = [String: String]()
        body["code"] = code
        return APIRequest<HIAPIUserToken>(service: self, endpoint: "/code/github/?redirect_uri=https://test.hackillinois.org/auth/?isiOS=1", body: body, method: .POST)
    }

}
