//
//  Contents.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

//: [Previous](@previous)

import Foundation
import SwiftKeychainAccess

var str = "Hello, playground"

//: [Next](@next)

struct HIUser: Codable {
    enum LoginMethod: Int, Codable {
        case github
        case userPass
    }

    enum CodingKeys: CodingKey {
        case loginMethod
        case token
        case identifier
    }

    var loginMethod: LoginMethod
    var token: String
    var identifier: String

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(loginMethod, forKey: .loginMethod)
        try container.encode(token, forKey: .token)
        try container.encode(identifier, forKey: .identifier)
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
        let encoded = try? JSONEncoder().encode(HIUser.self)
        return encoded ?? Data()
    }

}

let testUser = HIUser(loginMethod: HIUser.LoginMethod.github, token: "testtokebnenenen", identifier: "rauhul - github")
print(testUser)
let data = testUser.data
let decode = HIUser(data: data)

Keychain.default.allKeys()
Keychain.default.store(testUser, forKey: testUser.identifier)
Keychain.default.allKeys()
