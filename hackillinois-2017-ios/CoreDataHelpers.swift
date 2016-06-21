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
    class func createOrFetchLocation(location locationName: String, abbreviation shortName: String, locationLatitude latitude: NSNumber, locationLongitude longitude: NSNumber, locationFeeds feeds: [Feed]?) -> Location {
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
            location.initialize(latitude, longitude: longitude, name: locationName, shortName: shortName, feeds: NSSet())
        } else {
            location.initialize(latitude, longitude: longitude, name: locationName, shortName: shortName, feeds: feeds!)
        }
        
        return location
    }
    
    /* 
     * Helper function to find or create a tag
     * Finds the tag entity if it exists, otherwise returns a new entity representing a location object
     */
    class func createOrFetchTag(tag tagName: String, feeds: [Feed]?) -> Tag {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "Tag")
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
    
    /*
     * Helper function to load a context.
     * Supply the entity in which you want to load from.
     *
     * The fetchConfiguration is a function which will let you configure the request that takes place.
     * Pass in a function which takes a NSFetchRequest as an argument and returns a void. This NSFetchRequest should be
     * modified to configure the request to take place.
     *
     * Returns a AnyObject? since the entity may not exist
     */
    class func loadContext(entityName entityName: String, fetchConfiguration: (NSFetchRequest -> Void)?) -> AnyObject? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Fetch requested data
        let dataFetchReqeust = NSFetchRequest(entityName: entityName)
        
        // Configure the fetch request with user parameters
        if fetchConfiguration != nil {
            fetchConfiguration!(dataFetchReqeust)
        }
        
        do {
            return try appDelegate.managedObjectContext.executeFetchRequest(dataFetchReqeust)
        } catch {
            print("Failed to fetch feed data, critical error: \(error)")
        }
        
        return nil
    }
    
    /*
     * Helper function to update the last updated time
     */
    class func setLatestUpdateTime(time: NSDate) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(time, forKey: "timestamp")
    }
    
    /*
     * Helper function to obtain the last updated time
     */
    class func getLatestUpdateTime() -> NSDate? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey("timestamp") as? NSDate
    }
 
}

/* Helpers for User Profile */
extension Helpers {
    class func storeUser(name name: String, school: String, major: String, role: String, barcode: String, barcodeData: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: appDelegate.managedObjectContext) as! User
        user.initialize(name: name, school: school, major: major, role: role, barcode: barcode, barcodeData: barcodeData)
        
        self.saveContext()
    }
}

/* Helpers for HelpQ */
extension Helpers {
    class func storeHelpQItem(technology technology: String, language: String, location: String, description: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let helpQ = NSEntityDescription.insertNewObjectForEntityForName("HelpQ", inManagedObjectContext: appDelegate.managedObjectContext) as! HelpQ
        helpQ.initialize(technology, language: language, location: location, description: description)
        
        self.saveContext()
    }
    
    // To store chat items, use HelpQ.pushChatItem
}