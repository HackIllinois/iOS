//
//  HIUser.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import Keychain
import APIManager
import HIAPI

struct HIUser: Codable {
    var provider: HIAPI.AuthService.OAuthProvider
    var roles: HIAPI.Roles = []
    var attendee: HIAPI.Attendee?
    var token = ""
    var oauthCode = ""
    var id = ""
    var username = ""
    var firstName = ""
    var lastName = ""
    var email = ""

    var qrURL: URL? {
        return URL(string: "hackillinois://user?userId=\(id)")
    }

    init(provider: HIAPI.AuthService.OAuthProvider) {
        self.provider = provider
    }

    // Guest login
    init() {
        self.provider = .guest
    }
}

// MARK: - DataConvertible
extension HIUser: DataConvertible {
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(HIUser.self, from: data)
        } catch {
            return nil
        }
    }

    var data: Data {
        let encoded = try? JSONEncoder().encode(self)
        return encoded ?? Data()
    }
}

// MARK: - APIAuthorization
extension HIUser: APIAuthorization {
    public func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders? {
        var headers = HTTPHeaders()
        headers["Authorization"] = token
        return headers
    }
}
