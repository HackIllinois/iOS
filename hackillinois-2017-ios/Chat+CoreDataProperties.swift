//
//  Chat+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Chat {

    @NSManaged var message: String
    @NSManaged var time: NSDate
    @NSManaged var user: String
    @NSManaged var helpQ: HelpQ

}
