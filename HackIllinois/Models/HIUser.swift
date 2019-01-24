//
//  HIUser.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import SwiftKeychainAccess
import APIManager

enum HIUserPermissions: String, Codable, Comparable {

    case user = "User"
    case applicant = "Applicant"
    case attendee = "Attendee"
    case mentor = "Mentor"
    case sponsor = "Sponsor"
    case staff = "Staff"
    case admin = "Admin"

    private var intValue: Int {
        switch self {
        case .admin: return 6
        case .staff: return 5
        case .sponsor: return 4
        case .mentor: return 3
        case .attendee: return 2
        case .applicant: return 1
        case .user: return 0
        }
    }

    static func < (lhs: HIUserPermissions, rhs: HIUserPermissions) -> Bool {
        return lhs.intValue < rhs.intValue
    }
}

enum HIDietaryRestrictions: String, Codable {
    case none = "NONE"
    case vegetarian = "VEGETARIAN"
    case vegan = "VEGAN"
    case glutenFree = "GLUTEN_FREE"

    var displayText: String {
        switch self {
        case .none: return "NO DIETARY RESTRICTIONS"
        case .vegetarian: return "VEGETARIAN"
        case .vegan: return "VEGAN"
        case .glutenFree: return "GLUTEN FREE"
        }
    }
}

struct HIUser: Codable {
    var provider: HIAuthService.OAuthProvider
    var permissions: HIUserPermissions
    var token: String
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var dietaryRestrictions: HIDietaryRestrictions

    var qrInfo: String {
        return "hackillinois://user?userid=\(id)"
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
