//
//  HIAPIUser.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
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
            guard let permissions = HIUserPermissions(rawValue: role) else {
                throw DecodingError.typeMismatch(
                    HIUserPermissions.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.permissions],
                        debugDescription: "Role not aliased to any permission level"
                    )
                )
            }
            self.permissions = permissions
        }

    }
}
