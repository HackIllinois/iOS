//
//  HIAPIUser.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import APIManager
import Foundation

struct HIAPIUser: Codable, APIReturnable {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
}

struct HIAPIRolesContainer: Codable, APIReturnable {
    let roles: HIAPIRoles
}

struct HIAPIRoles: OptionSet, Codable {
    let rawValue: Int

    static let user = HIAPIRoles(rawValue: 1 << 0)
    static let applicant = HIAPIRoles(rawValue: 1 << 1)
    static let attendee = HIAPIRoles(rawValue: 1 << 2)
    static let mentor = HIAPIRoles(rawValue: 1 << 3)
    static let sponsor = HIAPIRoles(rawValue: 1 << 4)
    static let staff = HIAPIRoles(rawValue: 1 << 5)
    static let admin = HIAPIRoles(rawValue: 1 << 6)

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var options = [HIAPIRoles]()
        while !container.isAtEnd {
            let string = try container.decode(String.self)
            let option = try HIAPIRoles(string: string)
            options.append(option)
        }
        let null = HIAPIRoles(rawValue: 0)
        self = options.reduce(null) { return $0.union($1) }
    }

    init(string: String) throws {
        switch string {
        case "User": self = .user
        case "Applicant": self = .applicant
        case "Attendee": self = .attendee
        case "Mentor": self = .mentor
        case "Sponsor": self = .sponsor
        case "Staff": self = .staff
        case "Admin": self = .admin
        default: throw HIError.optionSetDecodingFailure
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        if contains(.user) { try container.encode("User") }
        if contains(.applicant) { try container.encode("Applicant") }
        if contains(.attendee) { try container.encode("Attendee") }
        if contains(.mentor) { try container.encode("Mentor") }
        if contains(.sponsor) { try container.encode("Sponsor") }
        if contains(.staff) { try container.encode("Staff") }
        if contains(.admin) { try container.encode("Admin") }
    }
}

struct HIAPIDietaryRestrictions: OptionSet, Codable, APIReturnable {
    let rawValue: Int

    static let vegan = HIAPIDietaryRestrictions(rawValue: 1 << 0)
    static let vegetarian = HIAPIDietaryRestrictions(rawValue: 1 << 1)
    static let nopeanut = HIAPIDietaryRestrictions(rawValue: 1 << 2)
    static let nogluten = HIAPIDietaryRestrictions(rawValue: 1 << 3)

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var options = [HIAPIDietaryRestrictions]()
        while !container.isAtEnd {
            let string = try container.decode(String.self)
            let option = try HIAPIDietaryRestrictions(string: string)
            options.append(option)
        }
        let null = HIAPIDietaryRestrictions(rawValue: 0)
        self = options.reduce(null) { return $0.union($1) }
    }

    init(string: String) throws {
        switch string {
        case "VEGAN": self = .vegan
        case "VEGETARIAN": self = .vegetarian
        case "NOPEANUT": self = .nopeanut
        case "NOGLUTEN": self = .nogluten
        default: throw HIError.optionSetDecodingFailure
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        if contains(.vegan) { try container.encode("VEGAN") }
        if contains(.vegetarian) { try container.encode("VEGETARIAN") }
        if contains(.nopeanut) { try container.encode("NOPEANUT") }
        if contains(.nogluten) { try container.encode("NOGLUTEN") }
    }
}

struct HIAPIAttendeeContainer: Codable, APIReturnable {
    let attendee: HIAPIAttendee
}

struct HIAPIAttendee: Codable, APIReturnable {
    let diet: HIAPIDietaryRestrictions
}

struct HIAPIToken: Codable, APIReturnable {
    var token: String
}
