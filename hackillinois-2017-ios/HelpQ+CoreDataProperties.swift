//
//  HelpQ+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/27/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HelpQ {

    @NSManaged var desc: String
    @NSManaged var initiation: NSDate
    @NSManaged var isHelping: NSNumber
    @NSManaged var language: String
    @NSManaged var location: String
    @NSManaged var modified: NSDate
    @NSManaged var resolved: NSNumber
    @NSManaged var technology: String
    @NSManaged var mentor: String
    @NSManaged var chats: NSOrderedSet

}
