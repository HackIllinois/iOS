//
//  HIUser.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import SwiftKeychainAccess

enum HILoginMethod: Int, Codable {
    case github
    case userPass
    case existing
}

enum HIUserPermissions: Int, Codable {
    case hacker
    case volunteer
    case staff
    case superUser
}

struct HIUser: Codable {
    var loginMethod: HILoginMethod
    var permissions: HIUserPermissions
    var token: String
    var identifier: String
    var isActive = false

    init(loginMethod: HILoginMethod, permissions: HIUserPermissions, token: String, identifier: String) {
        self.loginMethod = loginMethod
        self.permissions = permissions
        self.token = token
        self.identifier = identifier
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
