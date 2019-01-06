//
//  Location+CoreDataClass.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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
