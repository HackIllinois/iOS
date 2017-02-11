//
//  Feed+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 11/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed");
    }

    @NSManaged public var endTime: NSNumber?
    @NSManaged public var startTime: NSNumber?
    @NSManaged public var updated: NSNumber?
    @NSManaged public var description_: String?
    @NSManaged public var qrCode: NSNumber?
    @NSManaged public var shortName: String?
    @NSManaged public var name: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var locations: NSOrderedSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for locations
extension Feed {

    @objc(insertObject:inLocationsAtIndex:)
    @NSManaged public func insertIntoLocations(_ value: Location, at idx: Int)

    @objc(removeObjectFromLocationsAtIndex:)
    @NSManaged public func removeFromLocations(at idx: Int)

    @objc(insertLocations:atIndexes:)
    @NSManaged public func insertIntoLocations(_ values: [Location], at indexes: NSIndexSet)

    @objc(removeLocationsAtIndexes:)
    @NSManaged public func removeFromLocations(at indexes: NSIndexSet)

    @objc(replaceObjectInLocationsAtIndex:withObject:)
    @NSManaged public func replaceLocations(at idx: Int, with value: Location)

    @objc(replaceLocationsAtIndexes:withLocations:)
    @NSManaged public func replaceLocations(at indexes: NSIndexSet, with values: [Location])

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSOrderedSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tags
extension Feed {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
