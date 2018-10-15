//
//  Event+CoreDataProperties.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/25/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var end: Date
    @NSManaged public var id: Int16
    @NSManaged public var info: String
    @NSManaged public var name: String
    @NSManaged public var start: Date
    @NSManaged public var locations: NSSet

    @objc dynamic var sectionIdentifier: Date {
        let excessComponents: Set<Calendar.Component> = [.second, .nanosecond]
        return start.byRemoving(components: excessComponents)
    }

}

// MARK: Generated accessors for locations
extension Event {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
