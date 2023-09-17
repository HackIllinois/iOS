//
//  AuthService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class AuthService: BaseService {

    public override static var baseURL: String {
        return super.baseURL + "auth/"
    }

    public enum OAuthProvider: String, Codable {
        case github
        case google
        case guest

        public static let all: [OAuthProvider] = [.github, .google, .guest]

        public var displayName: String {
            switch self {
            case .github: return "ATTENDEE"
            case .google: return "STAFF"
            case .guest: return "GUEST"
            }
        }
    }
    // For HackIllinois 2024, we are only calling oauthURL because we do not make another call to get the token
    public static func oauthURL(provider: OAuthProvider) -> URL {
            guard let url = URL(string: AuthService.baseURL + "login/\(provider.rawValue)?device=ios") else {
                    fatalError("Invalid configuration.")
            }
            NSLog("using login URL" + "\(url)")
            return url
    }

    public static func getAPIToken(provider: OAuthProvider) -> APIRequest<Token> {
            let body = HTTPParameters()
            let temp = APIRequest<Token>(service: self, endpoint: AuthService.baseURL + "login/\(provider.rawValue)?device=ios", body: body, method: .GET)
            NSLog(temp.body?.description ?? "")
            return temp
    }

    public static func getRoles() -> APIRequest<RolesContainer> {
        return APIRequest<RolesContainer>(service: self, endpoint: "roles/", method: .GET)
    }

}
