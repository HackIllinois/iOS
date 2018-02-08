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
