//
//  FeedTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "feedCell"

class FeedTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    /* Variables */
    var refreshCleanUpRequired = false
    var dateTimeFormatter: DateFormatter!
    
    /* UI elements */
    @IBOutlet weak var feedTable: UITableView!
    
    /* Fetched results controller for lazy loading of cells */
    var fetchedResultsController: NSFetchedResultsController<Feed>!
    
    /* Cache of Tags to quickly generate the "Filter by..." menu */
    var tags: [Tag]!
    
    // Mark: Fetch function with predicate is already defined
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
            self.feedTable.reloadData()
        } catch {
            print("Error loading: \(error)")
        }
    }
    
    // Mark: Loading function for NSFetchedResultsController
    // Not generalized due to very specific quirks to it
    // TODO: find a way to generalize
    func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let fetch = NSFetchRequest<Feed>(entityName: "Feed")
            let sort = NSSortDescriptor(key: "time", ascending: false)
            fetch.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController<Feed>(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = nil
        performFetch()
    }
    
    func initializeSample() {
        // Make sure that the time stamp recieved is actually greater than our last updated time
        let lastUpdated: Date? = CoreDataHelpers.getLatestUpdateTime() as Date?
        if lastUpdated != nil {
            // Replace with actual timestamp
            if Date(timeIntervalSince1970: 1464042000).compare(lastUpdated!).rawValue <= 0 {
                return
            }
        }
        
        // Temporary Locations
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(location: "Siebel", abbreviation: "Siebel",locationLatitude: 40.113926, locationLongitude: -88.224916, locationFeeds: nil)
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(location: "ECEB", abbreviation: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, locationFeeds: nil)
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(location: "Illini Union", abbreviation: "Union", locationLatitude: 40.109395, locationLongitude: -88.227181, locationFeeds: nil)
        
        // Temporary Tags
        let tagGeneral = CoreDataHelpers.createOrFetchTag(tag: "General", feeds: nil)
        let tagFood = CoreDataHelpers.createOrFetchTag(tag: "Food", feeds: nil)
        let tagEvent = CoreDataHelpers.createOrFetchTag(tag: "Event", feeds: nil)
        let tagWorkshop = CoreDataHelpers.createOrFetchTag(tag: "Workshop", feeds: nil)
        
        // Temporary Events
        let _ = CoreDataHelpers.createFeed(id: 1, message: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                           timestamp: 1464038000, locations: [], tags: [tagGeneral])
        
        _ = CoreDataHelpers.createFeed(id: 2, message: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                           timestamp: 1464038763, locations: [siebel, eceb], tags: [tagFood])
        
        _ = CoreDataHelpers.createFeed(id: 3, message: "Cluehunt has begun!",
                           timestamp: 1464040073, locations: [siebel, eceb], tags: [tagEvent])
        
        _ = CoreDataHelpers.createFeed(id: 4, message: "Dinner is will be served in 10 minutes!",
                           timestamp: 1464042073, locations: [siebel, eceb], tags: [tagFood])
        
        _ = CoreDataHelpers.createFeed(id: 5, message: "Career fair is starting at the Union!",
                           timestamp: 1464042100, locations: [union], tags: [tagEvent])
        
        // Generate dummy data to simulate scrolling down
        for n in 0 ..< 7 {
            let time = UInt64(1464037000 - n*432)
            let _ = CoreDataHelpers.createFeed(id: NSNumber(value: 6 + n), message: "Cool look these cells are now dynamically size. This means that the more text there is per notification, the larger the cell gets!",
                               timestamp: time, locations: [siebel, eceb, union], tags: [tagWorkshop])
        }
        
        CoreDataHelpers.saveContext()
        CoreDataHelpers.setLatestUpdateTime(Date(timeIntervalSince1970: 1464042100))
    }
    
    // Mark - FeedCollectionViewController
    
    /* Refresh the feed... */
    func refresh() {
        feedTable.reloadData()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            // Check to see if the method previously failed.
            if self.refreshCleanUpRequired {
                self.refreshControl!.endRefreshing()
                // TODO: Different alert to user to wait a bit longer
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Timeout Error", message: "Please wait a little longer before trying again.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(ac, animated: true, completion: nil)
                }
                return
            }
            
            // Set timeout so the user isn't stuck with a long running process...
            var timeout = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timeoutIntervalSeconds * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                timeout = true
                self.refreshCleanUpRequired = true
                
                // End refresh
                self.refreshControl!.endRefreshing()
                // Present warning to user
                let ac = UIAlertController(title: "Network Error", message: "Network connection has timed out. Please check your internet connection and try again later.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(ac, animated: true, completion: nil)
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
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async { [unowned self] in
            let tempTags = CoreDataHelpers.loadContext(entityName: "Tag") {
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
        let alert = UIAlertController(title: "Filter by...", message: "Select tag to sort by", preferredStyle: .actionSheet)
        // Could be slow for many tags...
        for tag in tags {
            alert.addAction(UIAlertAction(title: tag.name, style: .default, handler: {
                [unowned self] alert in
                let predicate = NSPredicate(format: "ANY tags.name CONTAINS[cd] %@", alert.title!)
                self.fetchedResultsController.fetchRequest.predicate = predicate
                
                do {
                    try self.fetchedResultsController.performFetch()
                    self.feedTable.reloadData()
                } catch {
                    print("Error loading: \(error)")
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Default", style: .default, handler: { [unowned self] action in
            self.fetchedResultsController.fetchRequest.predicate = nil
            self.performFetch()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Mark: View configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 340


        // Uncomment the following line to preserve selection between presentations
        /* Preemptively load tags */
        loadTags()

        // Do any additional setup after loading the view.
        
        // Set the date formatting
        dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "MMMM dd 'at' h:mm a"
        
        // Set up refresh indicator
        // refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)])
        // Set refresh control look
        refreshControl?.tintColor = UIColor.fromRGBHex(mainTintColor)
        refreshControl?.bounds = CGRect(
            x: refreshControl!.bounds.origin.x,
            y: 50,
            width: refreshControl!.bounds.size.width,
            height: refreshControl!.bounds.size.height)
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        // Initialize Static data
        initializeSample()
        // Load objects from core data
        loadSavedData()
        
        // Create the "sort by..." feature
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_sort")!, style: .plain, target: self, action: #selector(showFilterBy))
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "feedDetail" {
            let destination = segue.destination as! FeedDetailViewController
            let feedItem = fetchedResultsController.object(at: feedTable.indexPathForSelectedRow!) 
            
            // Set up buildings
            destination.buildings = []
            
            if let locationArray = feedItem.locations?.array as? [Location] {
                for location in locationArray {
                    let building = Building(location: location)
                    destination.buildings.append(building)
                }
            }
            
            // Set up the message
            destination.message = feedItem.message
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event_cell") as! FeedTableViewCell
        let item = fetchedResultsController.object(at: indexPath) 
        
        cell.messageLabel.text = item.message
        cell.dateTimeLabel.text = dateTimeFormatter.string(from: item.time)
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
}
