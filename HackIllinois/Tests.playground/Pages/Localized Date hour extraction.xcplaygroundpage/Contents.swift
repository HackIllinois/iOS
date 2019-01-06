//
//  Contents.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/7/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

let calendar = Calendar.current
let date = Date()
let hour = calendar.component(.hour, from: date)
let minutes = calendar.component(.minute, from: date)
let seconds = calendar.component(.second, from: date)
print("hours = \(hour):\(minutes):\(seconds)")

let components = Calendar.current.dateComponents(
    [.calendar, .day, .era, .hour, .month, .quarter, .timeZone, .weekOfMonth, .weekOfYear, .weekday, .weekdayOrdinal, .year, .yearForWeekOfYear],
    from: date)

extension Date {
    func byRemoving(components: Set<Calendar.Component>) -> Date {
        let allComponents: Set<Calendar.Component> =
            [.calendar, .day, .era, .hour, .minute,
             .month, .nanosecond, .quarter, .second,
             .timeZone, .weekOfMonth, .weekOfYear,
             .weekday, .weekdayOrdinal, .year, .yearForWeekOfYear]

        let remainingComponents = allComponents.symmetricDifference(components)
        let remainingComponentsFromSelf = Calendar.current.dateComponents(remainingComponents, from: self)
        return Calendar.current.date(from: remainingComponentsFromSelf)!
    }
}

date
date.byRemoving(components: [.minute, .second, .nanosecond])
