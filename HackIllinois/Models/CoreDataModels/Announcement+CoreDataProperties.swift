//
//  Announcement+CoreDataProperties.swift
//  
//
//  Created by Rauhul Varma on 11/20/17.
//
//

import Foundation
import CoreData


extension Announcement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Announcement> {
        return NSFetchRequest<Announcement>(entityName: "Announcement")
    }

    @NSManaged public var info: String
    @NSManaged public var title: String
    @NSManaged public var id: Int16
    @NSManaged public var time: Date

}
