//
//  Event+CoreDataClass.swift
//  
//
//  Created by Rauhul Varma on 11/20/17.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject, Decodable {

    typealias Contained = HIAPIReturnDataContainer<Event>

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var end: Date
    @NSManaged public var id: Int16
    @NSManaged public var info: String
    @NSManaged public var name: String
    @NSManaged public var start: Date
    @NSManaged public var tag: Int16
    @NSManaged public var locations: NSSet

    private enum CodingKeys: String, CodingKey {
        case end = "endTime"
        case id
        case info = "description"
        case locations
        case name
        case start = "startTime"
        case tag = "tag"
    }

    public convenience init(context moc: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)
    }

    required convenience public init(from decoder: Decoder) throws {
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        self.init(context: backgroundContext)

        var anyError: Error?
        backgroundContext.performAndWait {
            do {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                end = try container.decode(Date.self, forKey: .end)
                id = try container.decode(Int16.self, forKey: .id)
                info = try container.decode(String.self, forKey: .info)
                name = try container.decode(String.self, forKey: .name)
                start = try container.decode(Date.self, forKey: .start)
                let stringTag = try container.decode(String.self, forKey: .tag)
                tag = (stringTag == "PRE_EVENT") ? 0 : 1
                try backgroundContext.save()
            } catch {
                anyError = error
            }
        }
        if let error = anyError {
            throw error
        }
    }

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Event)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Event)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
