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

struct HIUser: Codable {
    var loginMethod: HILoginMethod
    var token: String
    var identifier: String
}

// MARK: - DataConvertible
extension HIUser: DataConvertible {
    init?(data: Data) {
        do  {
            self = try JSONDecoder().decode(HIUser.self, from: data)
        } catch {
            return nil
        }
    }

    var data: Data {
        return try! JSONEncoder().encode(self)
    }
}
