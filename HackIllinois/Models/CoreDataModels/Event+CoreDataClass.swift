//
//  Event+CoreDataClass.swift
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
import HIAPI

@objc(Event)
public class Event: NSManagedObject {

    convenience init(context moc: NSManagedObjectContext, event: HIAPI.Event, locations: NSSet, favorite: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: moc) else { fatalError() }
        self.init(entity: entity, insertInto: moc)
        self.favorite = favorite
        name = event.name
        startTime = event.startTime
        endTime = event.endTime
        info = event.info
        sponsor = event.sponsor
        eventType = event.eventType
        self.locations = locations
    }

}
