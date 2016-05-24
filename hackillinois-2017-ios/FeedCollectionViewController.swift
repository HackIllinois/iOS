//
//  FeedCollectionViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "feedCell"

class FeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    /* Variables */
    var refreshCleanUpRequired = false
    var dateTimeFormatter: NSDateFormatter!
    
    
    /* UI elements */
    @IBOutlet weak var feedCollection: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    // Mark - Sample static data
    var sampleData: [Feed]!
    func initializeSample() {
        // Temporary Locations
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var siebel: Location!
        // Check if the location exists
        let siebelFetchRequest = NSFetchRequest(entityName: "Location")
        siebelFetchRequest.predicate = NSPredicate(format: "name == %@", "siebel")
        
        if let locations = try? appDelegate.managedObjectContext.executeFetchRequest(siebelFetchRequest) as! [Location] {
            if locations.count > 0 {
                siebel = locations[0]
            }
        }
        
        if siebel == nil {
            // siebel is missing
            let siebelEntity = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: appDelegate.managedObjectContext) as! Location
            siebelEntity.name = "siebel"
            siebelEntity.latitude = 40.1137074
            siebelEntity.longitude = -88.2264893
            siebelEntity.feeds = NSSet()
            
            siebel = siebelEntity
        }
        
        var eceb: Location!
        // Check if the location exists
        let ecebFetchRequest = NSFetchRequest(entityName: "Location")
        ecebFetchRequest.predicate = NSPredicate(format: "name == %@", "eceb")
        if let locations = try? appDelegate.managedObjectContext.executeFetchRequest(ecebFetchRequest) as! [Location] {
            if locations.count > 0 {
                eceb = locations[0]
            }
        }
        
        if eceb == nil {
            // eceb is missing
            let ecebEntity = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: appDelegate.managedObjectContext) as! Location
            ecebEntity.name = "eceb"
            ecebEntity.latitude = 40.114828
            ecebEntity.longitude = -88.228049
            ecebEntity.feeds = NSSet()
            
            eceb = ecebEntity
        }
        
        var union: Location!
        // Check if the location exists
        let unionFetchRequest = NSFetchRequest(entityName: "Location")
        unionFetchRequest.predicate = NSPredicate(format: "name == %@", "union")
        
        if let locations = try? appDelegate.managedObjectContext.executeFetchRequest(unionFetchRequest) as! [Location] {
            if locations.count > 0 {
                union = locations[0]
            }
        }
        
        if union == nil {
            // union is missing
            let unionEntity = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: appDelegate.managedObjectContext) as! Location
            unionEntity.name = "union"
            unionEntity.latitude = 40.109395
            unionEntity.longitude = -88.227181
            unionEntity.feeds = NSSet()
            
            union = unionEntity
        }
        
        let hackingStart = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        hackingStart.message = "Hacking has begun!"
        hackingStart.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464038000))
        hackingStart.locations = nil
        hackingStart.id = 1
        
        let lunch = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        lunch.message = "Lunch is served! Please come to ECEB or Siebel for Potbelly's Sandwiches!"
        lunch.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464038763))
        lunch.locations = NSSet(array: [siebel, eceb])
        lunch.id = 2
        
        let cluehuntStart = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        cluehuntStart.message = "Cluehunt has begun!"
        cluehuntStart.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464040073))
        cluehuntStart.locations = NSSet(array: [siebel, eceb])
        cluehuntStart.id = 3
        
        let dinner = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        dinner.message = "Dinner is going to be served in 10 minutes!"
        dinner.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464042073))
        dinner.locations = NSSet(array: [siebel, eceb])
        dinner.id = 4
        
        let careerFair = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
        careerFair.message = "Career fair is starting at the Union!"
        careerFair.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464042100))
        careerFair.locations = NSSet(object: union)
        careerFair.id = 5
        
        // Add to the feeds set to protect integrity
        siebel.feeds = siebel.feeds.setByAddingObjectsFromArray([lunch, cluehuntStart, dinner])
        eceb.feeds = eceb.feeds.setByAddingObjectsFromArray([lunch, cluehuntStart, dinner])
        union.feeds = union.feeds.setByAddingObject(careerFair)
        
        // Generate dummy data to simulate scrolling down
        for n in 0 ..< 7 {
            let dummy = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: appDelegate.managedObjectContext) as! Feed
            dummy.message = "Replace me with real things"
            dummy.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464037000 - n*432))
            dummy.locations = NSSet(array: [siebel, eceb, union])
            dummy.id = 6 + n
            
            siebel.feeds = siebel.feeds.setByAddingObject(dummy)
            eceb.feeds = eceb.feeds.setByAddingObject(dummy)
            union.feeds = union.feeds.setByAddingObject(dummy)
        }
        
        save()
    }
    
    func save() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Save context
        do {
            try appDelegate.managedObjectContext.save()
        } catch {
            print("Error occured while saving \(error)")
        }
    }
    
    func load() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Fetch feed data
        let dataFetchReqeust = NSFetchRequest(entityName: "Feed")
        let sort = NSSortDescriptor(key: "time", ascending: false)
        dataFetchReqeust.sortDescriptors = [sort]
        
        do {
            let feedData = try appDelegate.managedObjectContext.executeFetchRequest(dataFetchReqeust) as! [Feed]
            sampleData = feedData
        } catch {
            print("Failed to fetch feed data, critical error: \(error)")
        }
    }
    
    // Mark - FeedCollectionViewController
    
    /* Refresh the feed... */
    func refresh() {
        print("refresh")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // Check to see if the method previously failed.
            if self.refreshCleanUpRequired {
                self.refreshControl.endRefreshing()
                // TODO: Different alert to user to wait a bit longer
                dispatch_async(dispatch_get_main_queue()) {
                    let ac = UIAlertController(title: "Timeout Error", message: "Please wait a little longer before trying again.", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(ac, animated: true, completion: nil)
                }
                return
            }
            
            // Set timeout so the user isn't stuck with a long running process...
            var timeout = false
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeoutIntervalSeconds * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                timeout = true
                self.refreshCleanUpRequired = true
                
                // End refresh
                self.refreshControl.endRefreshing()
                // Present warning to user
                let ac = UIAlertController(title: "Network Error", message: "Network connection has timed out. Please check your internet connection and try again later.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(ac, animated: true, completion: nil)
                return
            }
            
            // Get information from server
            sleep(20) // Fake server response
            print("Post condd")
            
            if timeout {
                // clean up
                print("clean up")
                self.refreshCleanUpRequired = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        // Set the date formatting
        dateTimeFormatter = NSDateFormatter()
        dateTimeFormatter.dateFormat = "MMMM dd 'at' h:mm a"
        
        // Layout the view to look more natural
        feedCollection.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 20, right: 0)
        
        // Set up refresh indicator
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)])
        // Set refresh control look
        refreshControl.tintColor = UIColor.fromRGBHex(mainTintColor)
        refreshControl.bounds = CGRect(
            x: refreshControl.bounds.origin.x,
            y: 50,
            width: refreshControl.bounds.size.width,
            height: refreshControl.bounds.size.height)
        
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        feedCollection.addSubview(refreshControl)
        
        // Initialize Static data
        initializeSample()
        // Load objects from core data
        load()
        feedCollection.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath) as! FeedCollectionViewCell
        let feed = sampleData[indexPath.row]
        cell.dateTimeLabel.text = dateTimeFormatter.stringFromDate(feed.time)
        cell.messageLabel.text = feed.message
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
