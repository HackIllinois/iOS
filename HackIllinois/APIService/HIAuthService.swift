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
        return super.baseURL + "auth/"
    }

    enum OAuthProvider: String, Codable {
        case github
        case google
        case linkedIn = "linkedin"

        static let all: [OAuthProvider] = [.github, .google, .linkedIn]
    }

    static func oauthURL(provider: OAuthProvider) -> URL {
        guard let url = URL(string: HIAuthService.baseURL + "\(provider.rawValue)/?redirect_uri=https://hackillinois.org/auth/?isiOS=1") else { fatalError() }
        return url
    }

    static func getAPIToken(provider: OAuthProvider, code: String) -> APIRequest<HIAPIToken> {
        var body = HTTPParameters()
        body["code"] = code
        return APIRequest<HIAPIToken>(service: self, endpoint: "code/\(provider.rawValue)/?redirect_uri=https://hackillinois.org/auth/?isiOS=1", body: body, method: .POST)
    }

    static func getRoles() -> APIRequest<HIAPIRolesContainer> {
        return APIRequest<HIAPIRolesContainer>(service: self, endpoint: "roles/", method: .GET)
    }
}
