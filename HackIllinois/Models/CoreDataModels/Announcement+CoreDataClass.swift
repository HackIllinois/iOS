//
//  Announcement+CoreDataClass.swift
//  
//
//  Created by Rauhul Varma on 11/20/17.
//
//

import Foundation
import CoreData

@objc(Announcement)
public class Announcement: NSManagedObject, Decodable {
    typealias Contained = HIAPIReturnDataContainer<Announcement>

    enum CodingKeys: String, CodingKey {
        case id
        case info = "description"
        case time = "created"
        case title
    }

    public convenience init(context moc: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Announcement", in: moc) else { fatalError() }
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
                id = try container.decode(Int16.self, forKey: .id)
                info = try container.decode(String.self, forKey: .info)
                time = try container.decode(Date.self, forKey: .time)
                title = try container.decode(String.self, forKey: .title)
//                let locations = 

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
