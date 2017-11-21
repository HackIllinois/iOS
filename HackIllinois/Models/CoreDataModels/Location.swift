//
//  Location+CoreDataClass.swift
//  
//
//  Created by Rauhul Varma on 11/20/17.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Decodable {

    typealias Contained = HIAPIReturnDataContainer<Location>

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var events: NSSet
    @NSManaged public var id: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String

    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case name
    }

    public convenience init(context moc: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Location", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)
    }

    required public convenience init(from decoder: Decoder) throws {
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        self.init(context: backgroundContext)

        var anyError: Error?
        backgroundContext.performAndWait {
            do {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(Int16.self, forKey: .id)
                latitude = try container.decode(Double.self, forKey: .latitude)
                longitude = try container.decode(Double.self, forKey: .longitude)
                name = try container.decode(String.self, forKey: .name)
                try backgroundContext.save()
            } catch {
                anyError = error
            }
        }
        if let error = anyError {
            throw error
        }
    }

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
