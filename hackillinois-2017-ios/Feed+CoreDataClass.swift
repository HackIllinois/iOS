//
//  Feed+CoreDataClass.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 11/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


public class Feed: NSManagedObject {
    func initialize(id: NSNumber, description: String, startTime: Date, endTime: Date, updated: Date, qrCode: NSNumber, shortName: String, name: String, locations: NSOrderedSet?, tags: String) {
        self.id = id
        self.description_ = description
        self.startTime = startTime;
        self.endTime = endTime;
        self.updated_ = updated;
        self.qrCode = qrCode;
        self.shortName = shortName;
        self.name = name;
        self.locations = locations!;
        self.tag = tags;
    }
    
    @nonobjc func initialize(id: NSNumber, description: String, startTime: Date, endTime: Date, updated: Date, qrCode: NSNumber, shortName: String, name: String, locations: [Location], tag: String) {
        self.id = id
        self.description_ = description
        self.startTime = startTime;
        self.endTime = endTime;
        self.updated_ = updated;
        self.qrCode = qrCode;
        self.shortName = shortName;
        self.name = name;
        self.locations = NSOrderedSet(array: locations)
        self.tag = tag
        
        for location in locations {
            location.feeds = location.feeds.adding(self) as NSSet
        }
    }
}

