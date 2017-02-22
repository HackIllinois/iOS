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

class FeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, LocationButtonContainerDelegate {
    // MARK: - Global Variables
    var refreshCleanUpRequired = false
    var dateTimeFormatter: DateFormatter!
    // Cache of Tags to quickly generate the "Filter by..." menu
    var tags = [String]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        // Uncomment the following line to preserve selection between presentations
        /* Preemptively load tags */
        loadTags()
        
        
        //        // Set up refresh indicator
        //        // refreshControl = UIRefreshControl()
        //        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh",
        //                                                            attributes: [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)])
        //        // Set refresh control look
        //        refreshControl?.tintColor = UIColor.fromRGBHex(mainTintColor)
        //        refreshControl?.bounds = CGRect(
        //            x: refreshControl!.bounds.origin.x,
        //            y: 50,
        //            width: refreshControl!.bounds.size.width,
        //            height: refreshControl!.bounds.size.height)
        //
        //        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        initializeSample()
        // Load objects from core data
        loadSavedData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "feedDetail" {
            let destination = segue.destination as! FeedDetailViewController
            let feedItem = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
            
            // Set up buildings
            destination.buildings = []
            
            if let locationArray = feedItem.locations.array as? [Location] {
                for location in locationArray {
                    let building = Building(location: location)
                    destination.buildings.append(building)
                }
            }
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    // Fetched results controller for lazy loading of cells
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        fetchRequest.includesSubentities = false
        
        fetchRequest.predicate = NSPredicate(format: "tag == %@", "NOTIFICATION")
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    
    func loadSavedData() {
        fetchedResultsController.fetchRequest.predicate = nil
        fetch()
    }
    
    // Not generalized due to very specific quirks to it
    // TODO: find a way to generalize
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        tableView.reloadData()
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
        
        // I guess they are permanent locations now
        let dcl: Location! = CoreDataHelpers.createOrFetchLocation(id: 4, latitude: 40.113140, longitude: -88.226589, locationName: "Digital Computer Laboratory",  shortName: "DCL",  feeds: nil)
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(id: 1, latitude: 40.113926, longitude: -88.224916, locationName: "Thomas M. Siebel Center", shortName: "Siebel", feeds: nil)
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(id: 2,  latitude: 40.114828, longitude: -88.228049, locationName: "Electrical Computer Engineering Building", shortName: "ECEB", feeds: nil)
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(id: 3,  latitude: 40.109395, longitude: -88.227181,locationName: "Illini Union", shortName: "Union", feeds: nil)
        
        let date = Date(timeIntervalSince1970: 1486743300)
        // Temporary Events
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 1, description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "EVENT")
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 2, description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "EVENT")
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 3, description: "clue hunt", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "EVENT")
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 1, description: "Dinner gonna be rdy in 10", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "XD")
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 1, description: "career fair in the union", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "XD")
        
        // Generate dummy data to simulate scrolling down
        for n in 0 ..< 7 {
            let time = Date(timeIntervalSince1970: (TimeInterval(1464037000 - n*432)))
            let _ = CoreDataHelpers.createOrFetchFeed(id: NSNumber(value: 10 + n), description: "Cool look these cells are now dynamically size. This means that the more text there is per notification, the larger the cell gets!", startTime: time, endTime: time, updated: time, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, eceb, union], tag: "XD")
        }
        
        CoreDataHelpers.saveContext()
        CoreDataHelpers.setLatestUpdateTime(Date(timeIntervalSince1970: 1464042100))
    }
    
    // MARK: - FeedCollectionViewController
    func refresh() {
        tableView.reloadData()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            // Check to see if the method previously failed.
            if self.refreshCleanUpRequired {
//                self.refreshControl!.endRefreshing()
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
//                self.refreshControl!.endRefreshing()
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
        let tempFeed = CoreDataHelpers.loadContext(entityName: "Feed", fetchConfiguration: nil) as! [Feed]
        for feed in tempFeed {
            if !tags.contains(feed.tag) {
                tags.append(feed.tag)
            }
        }
    }
    
    // MARK: - Show filtering options...
    @IBAction func showFilterBy() {
        // Add the tags here...
        let alert = UIAlertController(title: "Filter by...", message: "Select tag to sort by", preferredStyle: .actionSheet)
        // Could be slow for many tags...
        for tag in tags {
            alert.addAction(UIAlertAction(title: tag, style: .default, handler: {
                [unowned self] alert in
                let predicate = NSPredicate(format: "tag == %@", tag)
                self.fetchedResultsController.fetchRequest.predicate = predicate
                
                do {
                    try self.fetchedResultsController.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print("Error loading: \(error)")
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Default", style: .default, handler: { [unowned self] action in
            self.fetchedResultsController.fetchRequest.predicate = nil
            self.fetch()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath)

        let identifier = item.locations.count > 0 ? "FeedTableViewLocationsCell" : "FeedTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? FeedTableViewCell {
            cell.delegate = self
            
            cell.titleLabel.text = item.shortName.uppercased()
            cell.detailLabel.text = item.description_
            cell.timeLabel.text = HLDateFormatter.shared.humanReadableTimeSince(date: item.startTime)
            
            cell.locations = item.locations.array as! [Location]
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    // MARK: - LocationButtonContainerDelegate
    func locationButtonTapped(location: Location) {
        print("did select location \(location.name): (\(location.latitude), \(location.longitude))")
        
    }
    
    
}
