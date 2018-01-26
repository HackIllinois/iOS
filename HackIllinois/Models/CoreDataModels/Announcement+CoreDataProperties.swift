//
//  Announcement+CoreDataProperties.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/25/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//
//

import Foundation
import CoreData


extension Announcement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Announcement> {
        return NSFetchRequest<Announcement>(entityName: "Announcement")
    }

    @NSManaged public var id: Int16
    @NSManaged public var info: String
    @NSManaged public var time: Date
    @NSManaged public var title: String

}
