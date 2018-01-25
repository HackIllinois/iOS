//
//  HIUser.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import SwiftKeychainAccess
import APIManager

enum HILoginMethod: Int, Codable {
    case github
    case userPass
}

enum HILoginSelection: Int {
    case github
    case userPass
    case existing
}

enum HIUserPermissions: String, Codable {
    case attendee = "ATTENDEE"
    case volunteer = "VOLUNTEER"
    case mentor = "MENTOR"
    case sponsor = "SPONSOR"
    case staff = "STAFF"
    case admin = "ADMIN"
}

struct HIUser: Codable {
    var loginMethod: HILoginMethod
    var permissions: HIUserPermissions
    var token: String
    var identifier: String
    var isActive: Bool
    var id: Int
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
    public func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders {
        var headers = HTTPHeaders()
        switch loginMethod {
        case .github:
            headers["Authorization"] = "Bearer \(token)"
        case .userPass:
            headers["Authorization"] = "Basic \(token)"
        }
        return headers
    }
}
