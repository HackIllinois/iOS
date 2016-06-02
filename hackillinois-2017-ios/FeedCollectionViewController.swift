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

class FeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    /* Variables */
    var refreshCleanUpRequired = false
    var dateTimeFormatter: NSDateFormatter!
    
    /* UI elements */
    @IBOutlet weak var feedCollection: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    /* Fetched results controller for lazy loading of cells */
    var fetchedResultsController: NSFetchedResultsController!
    
    /* Cache of Tags to quickly generate the "Filter by..." menu */
    var tags: [Tag]!
    
    // Mark: Fetch function with predicate is already defined
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
            self.feedCollection.reloadData()
        } catch {
            print("Error loading: \(error)")
        }
    }
    
    // Mark: Loading function for NSFetchedResultsController
    // Not generalized due to very specific quirks to it
    // TODO: find a way to generalize
    func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetch = NSFetchRequest(entityName: "Feed")
            let sort = NSSortDescriptor(key: "time", ascending: false)
            fetch.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = nil
        performFetch()
    }
    
    func initializeSample() {
        // Make sure that the time stamp recieved is actually greater than our last updated time
        let lastUpdated: NSDate? = Helpers.getLatestUpdateTime()
        if lastUpdated != nil {
            // Replace with actual timestamp
            if NSDate(timeIntervalSince1970: 1464042000).compare(lastUpdated!).rawValue <= 0 {
                print("Already updated")
                return
            }
        }
        
        // Temporary Locations
        let siebel: Location! = Helpers.createOrFetchLocation(location: "Siebel", locationLatitude: 40.113926, locationLongitude: -88.224916, locationFeeds: nil)
        
        let eceb: Location! = Helpers.createOrFetchLocation(location: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, locationFeeds: nil)
        
        let union: Location! = Helpers.createOrFetchLocation(location: "Illini Union", locationLatitude: 40.109395, locationLongitude: -88.227181, locationFeeds: nil)
        
        // Temporary Tags
        let tagGeneral = Helpers.createOrFetchTag(tag: "General", feeds: nil)
        let tagFood = Helpers.createOrFetchTag(tag: "Food", feeds: nil)
        let tagEvent = Helpers.createOrFetchTag(tag: "Event", feeds: nil)
        let tagWorkshop = Helpers.createOrFetchTag(tag: "Workshop", feeds: nil)
        
        // Temporary Events
        Helpers.createFeed(id: 1, message: "Hacking has begun!",
                           timestamp: 1464038000, locations: [], tags: [tagGeneral])
        
        Helpers.createFeed(id: 2, message: "Lunch is served! Please come to ECEB or Siebel for Potbelly's Sandwiches!",
                           timestamp: 1464038763, locations: [siebel, eceb], tags: [tagFood])
        
        Helpers.createFeed(id: 3, message: "Cluehunt has begun!",
                           timestamp: 1464040073, locations: [siebel, eceb], tags: [tagEvent])
        
        Helpers.createFeed(id: 4, message: "Dinner is will be served in 10 minutes!",
                           timestamp: 1464042073, locations: [siebel, eceb], tags: [tagFood])
        
        Helpers.createFeed(id: 5, message: "Career fair is starting at the Union!",
                           timestamp: 1464042100, locations: [union], tags: [tagEvent])
        
        // Generate dummy data to simulate scrolling down
        for n in 0 ..< 7 {
            let time = UInt64(1464037000 - n*432)
            Helpers.createFeed(id: 6 + n, message: "Replace me with real things",
                               timestamp: time, locations: [siebel, eceb, union], tags: [tagWorkshop])
        }
        
        Helpers.saveContext()
        Helpers.setLatestUpdateTime(NSDate(timeIntervalSince1970: 1464042100))
    }
    
    // Mark - FeedCollectionViewController
    
    /* Refresh the feed... */
    func refresh() {
        feedCollection.reloadData()
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
            
            if timeout {
                // clean up
                self.refreshCleanUpRequired = false
            }
        }
    }
    
    /* Value to load all tags */
    /* TODO: Hardcode tags instead? */
    func loadTags() {
        // Might need to change this to QOS_CLASS_USER_INITIATED, or it might not appear in time
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { [unowned self] in
            let tempTags = Helpers.loadContext(entityName: "Tag") {
                fetch in
                
                let sort = NSSortDescriptor(key: "name", ascending: true)
                fetch.sortDescriptors = [sort]
            }
            self.tags = tempTags as! [Tag]
        }
    }
    
    // Mark: Show filtering options...
    func showFilterBy() {
        // Add the tags here...
        let alert = UIAlertController(title: "Filter by...", message: "Select tag to sort by", preferredStyle: .ActionSheet)
        // Could be slow for many tags...
        for tag in tags {
            alert.addAction(UIAlertAction(title: tag.name, style: .Default, handler: {
                [unowned self] alert in
                let predicate = NSPredicate(format: "ANY tags.name CONTAINS[cd] %@", alert.title!)
                print("querying for \(alert.title!)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
                
                do {
                    try self.fetchedResultsController.performFetch()
                    self.feedCollection.reloadData()
                } catch {
                    print("Error loading: \(error)")
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Default", style: .Default, handler: { [unowned self] action in
            self.fetchedResultsController.fetchRequest.predicate = nil
            self.performFetch()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        /* Preemptively load tags */
        loadTags()

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
        loadSavedData()
        
        // Create the "sort by..." feature
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort by...", style: .Plain, target: self, action: #selector(showFilterBy))
        navigationItem.title = "Annoucements"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "feedDetail" {
            let destination = segue.destinationViewController as! FeedDetailViewController
            let feedItem = fetchedResultsController.objectAtIndexPath(feedCollection.indexPathsForSelectedItems()!.first!) as! Feed
            
            if let locationArray = feedItem.locations?.array as? [Location] {
                destination.locationArray = locationArray
            } else {
                destination.locationArray = []
            }
            
            destination.message = feedItem.message
        }
    }

    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(fetchedResultsController.sections![section].numberOfObjects)
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath) as! FeedCollectionViewCell
        let feed = fetchedResultsController.objectAtIndexPath(indexPath) as! Feed
        cell.dateTimeLabel.text = dateTimeFormatter.stringFromDate(feed.time)
        cell.messageLabel.text = feed.message
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("feedDetail", sender: sampleData[indexPath.row])
    }
    */

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
