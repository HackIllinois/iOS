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

import Foundation

struct HIAPIUser: Codable {
    typealias Contained = HIAPIReturnDataContainer<HIAPIUser>

    enum CodingKeys: String, CodingKey {
        case info = "user"
        case roles = "roles"
    }

    var info: Info
    var roles: [Role]

    struct Info: Codable {
        var id: Int
        var githubHandle: String?
        var email: String
    }

    struct Role: Codable {

        enum CodingKeys: String, CodingKey {
            case permissions = "role"
            case active = "active"
        }

        var permissions: HIUserPermissions
        var active: Bool

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let active = try container.decode(Int.self, forKey: .active)
            self.active = active == 1 ? true : false
            let role = try container.decode(String.self, forKey: .permissions)
            permissions = HIUserPermissions(rawValue: role) ?? .attendee
        }
    }
}
