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

class FeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, LocationButtonContainerDelegate {

    var tags = ["Hackathon", "Schedule"]
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        fetch()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: NSFetchedResultsControllerDelegate
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
            print("Failed to preform fetch operation, error: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Show filtering options...
    @IBAction func showFilterBy() {
        let alert = UIAlertController(title: "Filter by...", message: "Select tag to sort by", preferredStyle: .actionSheet)

        for tag in tags {
            alert.addAction(UIAlertAction(title: tag, style: .default, handler: {
                [weak self] alert in
                self?.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "tag == %@", tag.uppercased())
                self?.fetch()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Default", style: .default, handler: { [weak self] action in
            self?.fetchedResultsController.fetchRequest.predicate = nil
            self?.fetch()
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
        
        
    }
}
