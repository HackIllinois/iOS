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
public class Event: NSManagedObject {
    convenience init(context moc: NSManagedObjectContext, event: HIAPIEvent, locations: NSSet) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)
        favorite = event.favorite
        end = event.end
        id = event.id
        info = event.info
        name = event.name
        start = event.start
        self.locations = locations
    }
}
