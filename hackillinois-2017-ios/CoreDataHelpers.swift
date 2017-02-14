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
import Alamofire
import SwiftyJSON
/* Provide namespace for helpers */
class CoreDataHelpers {
    /* Mark - Helper functions to find location, tag, and create feeds */
    
    /* 
     * Helper function to find or create location 
     * Finds the location entity if it exists, otherwise returns a new entity representing a location object
     */
    class func createOrFetchLocation(idNum id: Int16, location locationName: String, abbreviation shortName: String, locationLatitude latitude: Float, locationLongitude longitude: Float, locationFeeds feeds: [Feed]?) -> Location {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "name == %@", locationName)
        
        if let locations = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            if locations.count > 0 {
                return locations[0]
            }
        }
        
        /* Was not found */
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: appDelegate.managedObjectContext) as! Location
        if feeds == nil {
            location.initialize(id: id, latitude: latitude, longitude: longitude, name: locationName, shortName: shortName, feeds: [])
        } else {
            location.initialize(id: id, latitude: latitude, longitude: longitude, name: locationName, shortName: shortName, feeds: feeds!)
        }
        
        return location
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
    class func createOrFetchFeed(id: NSNumber, description: String, startTime: Date, endTime: Date, updated: Date, qrCode: NSNumber, shortName: String, name: String, locations: [Location], tag: String) -> Feed {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let feed = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            if feed.count > 0 {
                return feed[0]
            }
        }
        
        let feed = NSEntityDescription.insertNewObject(forEntityName: "Feed", into: appDelegate.managedObjectContext) as! Feed
//        feed.initialize(id: id, message: message, time: Date(timeIntervalSince1970: TimeInterval(timestamp)), locations: locations, tags: tags)
        feed.initialize(id: id, description: description, startTime: startTime, endTime: endTime, updated: updated, qrCode: qrCode, shortName: shortName, name: name, locations: locations, tag: tag)
        return feed
    }
    
    /*
     * Helper function to save the context 
     * Written to be asynchronous and nonobstructive (high priority) to prevent the main UI from freezing when it occurs
     */
    class func saveContext() {
        DispatchQueue.global(qos: .userInitiated).async() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
     * Helper function to save the context
     * Written to be done on the main thread instead of an asynchronous thread
     */
    class func saveContextMainThread() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.managedObjectContext.hasChanges {
            do {
                try appDelegate.managedObjectContext.save()
            } catch {
                print("Error while saving \(error)")
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
    class func loadContext(entityName: String, fetchConfiguration: ((NSFetchRequest<NSManagedObject>) -> Void)?) -> [NSManagedObject]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Fetch requested data
        let dataFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        // Configure the fetch request with user parameters
        fetchConfiguration?(dataFetchRequest)
        
        do {
            return try appDelegate.managedObjectContext.fetch(dataFetchRequest)
        } catch {
            print("Failed to fetch feed data, critical error: \(error)")
        }
        
        return nil
    }
    
    /*
     * Helper function to update the last updated time
     */
    class func setLatestUpdateTime(_ time: Date) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "timestamp")
    }
    
    /*
     * Helper function to obtain the last updated time
     */
    class func getLatestUpdateTime() -> Date? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "timestamp") as? NSDate as Date?
    }
    
    /* fetch the newest JSON data from the server */
    class func updateEventsFeed() {
        print ("update events feed called")
        // MARK: change the APIURL to the real one
        let eventsAPIURL = "http://13.90.146.188:8080/v1/events"
        Alamofire.request(eventsAPIURL)
            .responseJSON { response in
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    for feedJSON in json["data"].arrayValue {
                        CoreDataHelpers.configure(feedJSON: feedJSON);
                    }
                }
        }
        CoreDataHelpers.saveContext()
    }
    
    /* initializes Feed object from JSON */
    class func configure(feedJSON: JSON) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let id = feedJSON["id"].numberValue
        let name = feedJSON["name"].stringValue
        let shortName = feedJSON["shortName"].stringValue
        let qrCode = feedJSON["qrcode"].numberValue
        let description = feedJSON["description"].stringValue
        let updated = stringToDate(date: feedJSON["updated"].stringValue)
        let startTime = stringToDate(date: feedJSON["startTime"].stringValue)
        let endTime = stringToDate(date: feedJSON["endTime"].stringValue)
        let tag = feedJSON["tag"].stringValue
        let locations = feedJSON["locations"]
        var tempLocations:[Location] = []
        for location in locations {
            let locationObject = NSEntityDescription.insertNewObject(forEntityName: "Location", into: appDelegate.managedObjectContext) as! Location
            let id = location.1["id"].int16Value
            let latitude = location.1["latitude"].floatValue
            let longitude = location.1["longitude"].floatValue
            let shortName = location.1["shortName"].stringValue
            let name = location.1["name"].stringValue
            locationObject.initialize(id: id, latitude: latitude, longitude: longitude, name: shortName, shortName: name, feeds: [])
            tempLocations.append(locationObject)
        }
        let l = CoreDataHelpers.createOrFetchFeed(id: id, description: description, startTime: startTime, endTime: endTime, updated: updated, qrCode: qrCode, shortName: shortName, name: name, locations: tempLocations, tag: tag)
        print(l)
    }
    
    /* converts date string to date object */
    class func stringToDate(date: String) -> Date
    {
        // the format below is the javascript simple date format
        // the Z represents GMT timezone (+0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "CST") as TimeZone!
        let dateObject = dateFormatter.date(from: date)
        return dateObject!
    }
     
}

/* Helpers for User Profile */
extension CoreDataHelpers {
    class func storeUser(name: String, email: String, school: String, major: String, role: String, barcode: String, barcodeData: Data, auth: String, initTime: Date, expirationTime: Date, userID: NSNumber, diet: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: appDelegate.managedObjectContext) as! User
        user.initialize(name: name, email: email, school: school, major: major, role: role, barcode: barcode, barcodeData: barcodeData, token: auth, initTime: initTime, expirationTime: expirationTime, userID: userID, diet: diet)
        
        self.saveContext()
    }
}

/* Helpers for HelpQ */
extension CoreDataHelpers {
    class func createHelpQItem(technology: String, language: String, location: String, description: String) -> HelpQ {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let helpQ = NSEntityDescription.insertNewObject(forEntityName: "HelpQ", into: appDelegate.managedObjectContext) as! HelpQ
        helpQ.initialize(technology: technology, language: language, location: location, description: description)
        
        return helpQ
    }
    
    // To store chat items, use HelpQ.pushChatItem
}
