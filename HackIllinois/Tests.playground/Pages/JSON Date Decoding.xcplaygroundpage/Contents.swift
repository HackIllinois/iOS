//
//  Contents.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

//: Playground - noun: a place where people can play

import Foundation

let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
}()

let iso8601withoutMS: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    return formatter
}()

struct JustADate: Codable, APIReturnable {
    let date: Date

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(JustADate.self, from: data)
        print("override")
    }
}

let decoder1 = JSONDecoder()
decoder1.dateDecodingStrategy = .formatted(iso8601)
let decoder2 = JSONDecoder()
decoder2.dateDecodingStrategy = .formatted(iso8601withoutMS)
let decoder3 = JSONDecoder()
decoder3.dateDecodingStrategy = .secondsSince1970
let decoder4 = JSONDecoder()
decoder4.dateDecodingStrategy = .millisecondsSince1970

let json1 = """
{ "date": "2017-06-19T18:43:19.532Z" }
"""
let json2 = """
{ "date": 1548473562 }
"""

[json1, json2].forEach { json in
    print(json)
    let data = Data(json.utf8)
    [decoder1, decoder2, decoder3, decoder4].forEach { decoder in
        do {
            let container = (try decoder.decode(JustADate.self, from: data))
            print(container.date)
        } catch {
            print(error)
        }
    }
    print("")
}

// From APIManager
public protocol APIReturnable {
    init(from data: Data) throws
}

public extension APIReturnable where Self: Decodable {
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
        print("base")
    }
}

do {
    let container = try JustADate.init(from: Data(json2.utf8))
    print(container.date)
} catch {
    print(error)
}
