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
public class Location: NSManagedObject {
    convenience init(context moc: NSManagedObjectContext, location: HIAPILocation) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Location", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)

        id = Int16(location.id)
        name = location.name
        longitude = location.longitude
        latitude = location.latitude
    }
}
