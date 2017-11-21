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

}
