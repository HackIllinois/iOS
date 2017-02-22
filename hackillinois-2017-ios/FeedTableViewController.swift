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
        // Load objects from core data
        fetch()
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
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - FeedCollectionViewController
    
//     Value to load all tags 
//     TODO: Hardcode tags instead?
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
        // TODO: - Implement this
        print("did select location \(location.name): (\(location.latitude), \(location.longitude))")
        
        
    }
}
