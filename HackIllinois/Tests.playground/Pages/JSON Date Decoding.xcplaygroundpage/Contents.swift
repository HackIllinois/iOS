//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static let iso8601withoutMS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}

struct JustADate: Codable {
    let date: Date
}

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
let decoder2 = JSONDecoder()
decoder2.dateDecodingStrategy = .formatted(Formatter.iso8601withoutMS)

let json = """
{ "date": "2017-06-19T18:43:19.532Z" }
"""
let data = Data(json.utf8)

if let justADate = (try? decoder.decode(JustADate.self, from: data)) ??
    (try? decoder2.decode(JustADate.self, from: data)) {
    Formatter.iso8601.string(from: justADate.date)    // "2017-06-19T18:43:19.532Z"
}



let time = Date.init(timeInterval: -1000, since: Date())

Date().timeIntervalSince(time)
