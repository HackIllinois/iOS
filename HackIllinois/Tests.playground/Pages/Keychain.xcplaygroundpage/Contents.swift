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
        do  {
            self = try JSONDecoder().decode(HIUser.self, from: data)
        } catch {
            return nil
        }
    }

    var data: Data {
        return try! JSONEncoder().encode(HIUser.self)
    }

}

let testUser = HIUser(loginMethod: HIUser.LoginMethod.github, token: "testtokebnenenen", identifier: "rauhul - github")
print(testUser)
let data = testUser.data
let decode = HIUser(data: data)

Keychain.default.allKeys()
Keychain.default.store(testUser, forKey: testUser.identifier)
Keychain.default.allKeys()
