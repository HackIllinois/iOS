//
//  Feed.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


class Feed: NSManagedObject {

    /* Convenience update function */
    func initialize(id: NSNumber, message: String, time: NSDate, locations: NSOrderedSet?, tags: NSSet?) {
        self.id = id
        self.message = message
        self.time = time
        self.locations = locations
        self.tags = tags
    }
    
    /* Overrides needs nonobjc methods to compile */
    /* If tags and locations already exist, this method will add this feed to the corresponding location and tag */
    @nonobjc func initialize(id: NSNumber, message: String, time: NSDate, locations: [Location], tags: [Tag]) {
        self.id = id
        self.message = message
        self.time = time
        self.locations = NSOrderedSet(array: locations)
        self.tags = NSSet(array: tags)
        
        for location in locations {
            location.feeds = location.feeds.setByAddingObject(self)
        }
        
        for tag in tags {
            tag.feeds = tag.feeds.setByAddingObject(self)
        }
    }
}
