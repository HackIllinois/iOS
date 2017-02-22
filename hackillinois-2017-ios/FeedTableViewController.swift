//
//  FeedTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

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
        
        // Preemptively load tags
        loadTags()
        // The following line generates hardcoded notification data
        // initializeSample()
        attemptPullingEventData()
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
        
        fetchRequest.predicate = NSPredicate(format: "tag == %@", "EVENT")
        
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
    
    // MARK: - Events Logic
    func attemptPullingEventData() {
        APIManager.shared.getEvents(success: getEventsSuccess, failure: getEventsFailure)
    }
    
    func getEventsSuccess(json: JSON) {
        if let error = json["error"]["message"].string {
            presentErrorLabel(text: error)
        } else if let key = json["data"]["auth"].string {
//            APIManager.shared.setAuthKey(key)
//            APIManager.shared.getUserInfo(success: getUserInfoSuccess, failure: getEventsFailure)
        }
//        else {
//        }
    }

    
    func getEventsFailure(error: Error) {
        presentErrorLabel(text: error as! String)

    }
    
    // MARK: - Events UI
    func presentErrorLabel(text: String) {
        print("ERROR: \(text)")
//        let alert = UIAlertController()
//        alert.title = "Unknown error"
//        alert.message = text
//        alert.show(<#UIViewController#>)
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
