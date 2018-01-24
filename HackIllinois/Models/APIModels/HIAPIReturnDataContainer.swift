//
//  HIAPIReturnDataContainer.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

struct HIAPIReturnDataContainer<Model: Decodable>: Decodable, APIReturnable {
    var meta: String?
    var data: [Model]

    enum CodingKeys: CodingKey {
        case meta
        case data
    }

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
        self = try decoder.decode(HIAPIReturnDataContainer.self, from: data)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decodeIfPresent(String.self, forKey: .meta)
        do {
            data = try container.decode([Model].self, forKey: .data)
        } catch _ {
            let singleDataValue = try container.decode(Model.self, forKey: .data)
            data = [singleDataValue]
        }
    }
}
