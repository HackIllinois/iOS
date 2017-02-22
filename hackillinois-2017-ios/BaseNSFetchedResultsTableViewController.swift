//
//  BaseNSFetchedResultsTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 2/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class BaseNSFetchedResultsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, LocationButtonContainerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let eventDetailsVC = segue.destination as? EventDetailsViewController,
            let feed = sender as? Feed {
            eventDetailsVC.event = feed
        }
        
        if let mapVC = segue.destination as? MapViewController,
            let location = sender as? Location  {
            mapVC.isDirectionMode = true
            mapVC.directionModeLabel = LocationIdMapper.getLocalId(fromShortname: location.shortName)
            mapVC.directionModeTitle = location.name
            mapVC.hidesBottomBarWhenPushed = true
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true), NSSortDescriptor(key: "shortName", ascending: true)]
        fetchRequest.includesSubentities = false
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func fetch() {
        do {
            fetchedResultsController.fetchRequest.predicate = predicate()
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Failed to preform fetch operation, error: \(error)")
        }
        tableView.reloadData()
    }
    
    func predicate() -> NSPredicate? {
        return nil
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            break
            guard let updateIndexPath = indexPath else { return }
            tableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [toIndexPath],   with: .fade)
            tableView.deleteRows(at: [fromIndexPath], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .fade)
        case .update:
            tableView.reloadSections([sectionIndex], with: .fade)
        case .move:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - LocationButtonContainerDelegate
    func locationButtonTapped(location: Location) {
        performSegue(withIdentifier: "showMap", sender: location)
    }
}
