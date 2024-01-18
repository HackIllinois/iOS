//
//  Item.swift
//  HIAPI
//
//  Created by HackIllinois on 1/2/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

public struct ItemContainer: Decodable, APIReturnable {
    public let items: [Item]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.items = try container.decode([Item].self)
    }
}

public struct Item: Codable {
    internal enum CodingKeys: String, CodingKey {
        case name
        case price
        case isRaffle
        case quantity
    }
    public let name: String
    public let price: Int
    public let isRaffle: Bool
    public let quantity: Int
}
