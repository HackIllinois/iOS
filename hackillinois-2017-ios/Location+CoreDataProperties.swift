//
//  Location+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/9/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: Float
    @NSManaged var longitude: Float
    @NSManaged var name: String
    @NSManaged var shortName: String
    @NSManaged var feeds: NSSet
    @NSManaged var id: Int16

}
