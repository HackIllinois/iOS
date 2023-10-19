//
//  User.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import APIManager
import Foundation

public struct User: Codable, APIReturnable {
    public let userId: String
    public let email: String
}

public struct RolesContainer: Codable, APIReturnable {
    public let roles: Roles
}

public struct Roles: OptionSet, Codable {
    public let rawValue: Int

    public static let null = Roles([])
    public static let USER = Roles(rawValue: 1 << 0)
    public static let APPLICANT = Roles(rawValue: 1 << 1)
    public static let ATTENDEE = Roles(rawValue: 1 << 2)
    public static let MENTOR = Roles(rawValue: 1 << 3)
    public static let SPONSOR = Roles(rawValue: 1 << 4)
    public static let STAFF = Roles(rawValue: 1 << 5)
    public static let ADMIN = Roles(rawValue: 1 << 6)
    public static let allRoles = ["USER", "APPLICANT", "ATTENDEE", "MENTOR", "SPONSOR", "STAFF", "ADMIN"]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var options = [Roles]()
        while !container.isAtEnd {
            let string = try container.decode(String.self)
            let option = try Roles(string: string)
            options.append(option)
        }
        self = options.reduce(.null) { return $0.union($1) }
    }

    public init(string: String) throws {
        switch string {
        case "USER": self = .USER
        case "APPLICANT": self = .APPLICANT
        case "ATTENDEE": self = .ATTENDEE
        case "MENTOR": self = .MENTOR
        case "SPONSOR": self = .SPONSOR
        case "STAFF": self = .STAFF
        case "ADMIN": self = .ADMIN
        default:
            #if DEBUG
                throw DecodingError.unknownOption
            #else
                self = .null
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        if contains(.USER) { try container.encode("USER") }
        if contains(.APPLICANT) { try container.encode("APPLICANT") }
        if contains(.ATTENDEE) { try container.encode("ATTENDEE") }
        if contains(.MENTOR) { try container.encode("MENTOR") }
        if contains(.SPONSOR) { try container.encode("SPONSOR") }
        if contains(.STAFF) { try container.encode("STAFF") }
        if contains(.ADMIN) { try container.encode("ADMIN") }
    }
}

fileprivate extension Optional where Wrapped == String {
    static func += (lhs: inout String?, rhs: String) {
        if lhs == nil {
            lhs = rhs
        } else {
            lhs! += rhs
        }
    }
}

public struct QRData: Codable, APIReturnable {
    public let id: String
    public let qrInfo: String
}

public struct DietaryRestrictions: OptionSet, Codable, APIReturnable {
    public let rawValue: Int

    public static let vegan = DietaryRestrictions(rawValue: 1 << 0)
    public static let vegetarian = DietaryRestrictions(rawValue: 1 << 1)
    public static let nopeanut = DietaryRestrictions(rawValue: 1 << 2)
    public static let nogluten = DietaryRestrictions(rawValue: 1 << 3)

    public var description: String? {
        var description: String?

        var veganVegetarianDescription: String?
        if contains(.vegan) {
            veganVegetarianDescription += "VEGAN"
        } else if contains(.vegetarian) {
            veganVegetarianDescription += "VEGETARIAN"
        }

        var allergyDescription: String?
        if contains(.nopeanut) {
            allergyDescription += "PEANUT"
        }

        if contains(.nogluten) {
            if allergyDescription != nil {
                allergyDescription += " AND "
            }
            allergyDescription += "GLUTEN"
        }

        if allergyDescription != nil {
            allergyDescription += " ALLERGY"
        }

        if let veganVegetarianDescription = veganVegetarianDescription {
            description += veganVegetarianDescription
        }

        if let allergyDescription = allergyDescription {
            if description != nil {
                description += ", "
            }
            description += allergyDescription
        }

        return description
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var options = [DietaryRestrictions]()
        while !container.isAtEnd {
            let string = try container.decode(String.self)
            let option = try DietaryRestrictions(string: string)
            options.append(option)
        }
        let null = DietaryRestrictions(rawValue: 0)
        self = options.reduce(null) { return $0.union($1) }
    }

    internal init(string: String) throws {
        switch string {
        case "VEGAN": self = .vegan
        case "VEGETARIAN": self = .vegetarian
        case "NOPEANUT": self = .nopeanut
        case "NOGLUTEN": self = .nogluten
        default: throw DecodingError.unknownOption
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        if contains(.vegan) { try container.encode("VEGAN") }
        if contains(.vegetarian) { try container.encode("VEGETARIAN") }
        if contains(.nopeanut) { try container.encode("NOPEANUT") }
        if contains(.nogluten) { try container.encode("NOGLUTEN") }
    }
}

public struct Token: Codable, APIReturnable {
    public let token: String
}
