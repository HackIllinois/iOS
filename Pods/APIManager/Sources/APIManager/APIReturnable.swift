//
//  APIReturnable.swift
//  APIManager
//
//  Created by Rauhul Varma on 10/29/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/// Defines the methods required for an object to be returned by an `APIService`
public protocol APIReturnable {

    /// Defines how to convert returned `Data` into an `APIReturnable` object
    init(from data: Data) throws
}

/// Extension to allow for `Decodable` objects to be intately `APIReturnable`
public extension APIReturnable where Self: Decodable {

    /// Conversion from `Data` to a `Decodable` type using a `JSONDecoder`
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
