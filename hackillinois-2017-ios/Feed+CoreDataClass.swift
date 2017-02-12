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
    func initialize(id: NSNumber, description: String, startTime: Date, endTime: Date, updated: Date, qrCode: NSNumber, shortName: String, name: String, locations: NSOrderedSet?, tags: NSSet?) {
        self.id = id
        self.description_ = description
        self.startTime = startTime;
        self.endTime = endTime;
        self.updated_ = updated;
        self.qrCode = qrCode;
        self.shortName = shortName;
        self.name = name;
        self.locations = locations;
        self.tags = tags;
    }
    
    @nonobjc func initialize(id: NSNumber, description: String, startTime: Date, endTime: Date, updated: Date, qrCode: NSNumber, shortName: String, name: String, locations: [Location], tags: [Tag]) {
        self.id = id
        self.description_ = description
        self.startTime = startTime;
        self.endTime = endTime;
        self.updated_ = updated;
        self.qrCode = qrCode;
        self.shortName = shortName;
        self.name = name;
        self.locations = NSOrderedSet(array: locations)
        self.tags = NSSet(array: tags)
        
        for location in locations {
            location.feeds = location.feeds.adding(self) as NSSet
        }
        
        for tag in tags {
            tag.feeds = tag.feeds.adding(self) as NSSet
        }
    }
}

