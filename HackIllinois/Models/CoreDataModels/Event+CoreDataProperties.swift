//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Rauhul Varma on 11/20/17.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var end: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var start: NSDate?
    @NSManaged public var tag: Int16
    @NSManaged public var locations: NSSet?

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
