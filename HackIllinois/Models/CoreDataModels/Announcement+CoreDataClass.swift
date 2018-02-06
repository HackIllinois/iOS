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
public class Announcement: NSManagedObject {
    convenience init(context moc: NSManagedObjectContext, announcement: HIAPIAnnouncement) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Announcement", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)
        id = announcement.id
        info = announcement.info
        title = announcement.title
        time = announcement.time
    }
}
