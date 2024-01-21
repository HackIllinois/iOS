//
//  HIProfile.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import Keychain
import APIManager
import HIAPI

struct HIProfile: Codable {
    var provider: HIAPI.AuthService.OAuthProvider
    var roles: HIAPI.Roles = []
    var attendee: HIAPI.Attendee?
    var token = ""
    var oauthCode = ""
    var userId = ""
    var displayName = ""
    var points = 0
    //var foodWave = 0
    var timezone = ""
    var discordTag = ""
    var avatarUrl = ""
    var coins = 0
    
    init(provider: HIAPI.AuthService.OAuthProvider) {
        self.provider = provider
    }

    // Guest login
    init() {
        self.provider = .guest
    }
}

// MARK: - DataConvertible
extension HIProfile: DataConvertible {
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(HIProfile.self, from: data)
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
extension HIProfile: APIAuthorization {
    public func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders? {
        var headers = HTTPHeaders()
        headers["Authorization"] = token
        return headers
    }
}
