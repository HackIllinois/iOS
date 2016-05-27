//
//  CoreDataHelpers.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/27/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

/* This file contains helper functions for CoreData operations */
import CoreData
import UIKit

/* Provide namespace for helpers */
class Helpers {
    
    /* Mark - Helper functions to find location, tag, and create feeds */
    
    /* 
     * Helper function to find or create location 
     * Finds the location entity if it exists, otherwise returns a new entity representing a location object
     */
    class func createOrFetchLocation(location locationName: String, locationLatitude latitude: NSNumber, locationLongitude longitude: NSNumber, locationFeeds feeds: [Feed]?) -> Location {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "name == %@", locationName)
        
        if let locations = try? appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) {
            if locations.count > 0 {
                return locations[0] as! Location
            }
        }
        
        /* Was not found */
        let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: appDelegate.managedObjectContext) as! Location
        if feeds == nil {
            location.initialize(latitude, longitude: longitude, name: locationName, feeds: NSSet())
        } else {
            location.initialize(latitude, longitude: longitude, name: locationName, feeds: feeds!)
        }
        
        return location
    }
    
    /* 
     * Helper function to find or create a tag
     * Finds the tag entity if it exists, otherwise returns a new entity representing a location object
     */
    class func createOrFetchTag(tag tagName: String, feeds: [Feed]?) -> Tag {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "tag")
        fetchRequest.predicate = NSPredicate(format: "name == %@", tagName)
        
        if let tags = try? appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) {
            if tags.count > 0 {
                return tags[0] as! Tag
            }
        }
        
        /* Was not found */
        let tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: appDelegate.managedObjectContext) as! Tag
        
        if feeds == nil {
            tag.initialize(tagName, feeds: NSSet())
        } else {
            tag.initialize(tagName, feeds: feeds!)
        }
        
        return tag
    }
    
    /* 
     * Helper function to create a feed
     * Finds a feed entity if it exists, otherwise returns a new entity representing a feed object
     * The database's Merge Policy is set to overwrite, so passing in the same id will overwrite the existing entry.
     * 
     * If there are valid locations and tags passed in, this will also add the object to each of the inverse relationships
     * Thus it is recommended to create the tags+locations before passing it in as arguments.
     *
     * locations and tags seems required, you can insert an empty array/list if it doesn't exist (done in order to have the
     * user have to make an intention not to have any locations or tags
     */
    class func createFeed(id id: NSNumber, message: String, timestamp: UInt64, locations: [Location], tags: [Tag]) -> Feed {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let feed = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        feed.initialize(id, message: message, time: NSDate(timeIntervalSince1970: NSTimeInterval(timestamp)), locations: locations, tags: tags)
        return feed
    }
    
    /*
     * Helper function to save the context 
     * Written to be asynchronous and nonobstructive (high priority) to prevent the main UI from freezing when it occurs
     */
    class func saveContext() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if appDelegate.managedObjectContext.hasChanges {
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                    print("Error while saving: \(error)")
                }
            }
        }
    }
    
}