//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, QRButtonDelegate, LocationButtonContainerDelegate {
    
    // MARK: - Enums
    enum HackathonStatus {
        case beforeHackathon
        case beforeHacking
        case duringHacking
        case afterHackathon
        
        static var current: HackathonStatus {
            let time = Date()
            // MARK: change me
            return .beforeHacking
            if time < HACKATHON_BEGIN_TIME {
                return .beforeHackathon
            } else if time < HACKING_BEGIN_TIME {
                return .beforeHacking
            } else if time < HACKING_END_TIME {
                return .duringHacking
            } else {
                return .afterHackathon
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.estimatedRowHeight = 200
        
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let eventDetailsVC = segue.destination as? EventDetailsViewController,
           let indexPath = sender as? IndexPath {
            let offsetIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section);
            eventDetailsVC.event = fetchedResultsController.object(at: offsetIndexPath)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let events = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
        switch HackathonStatus.current {
        case .beforeHackathon, .afterHackathon:
            return 1
        case .beforeHacking, .duringHacking:
            return events + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        
        /*****
         *      This is for the top cell => Regardless of which part of the event we are in,
         *      the cell will contain status information regarding the hackathon
         *      ie. "Hacking begins in xx Hours xx Minutes xx seconds"
         *      or "Submit Projects in xx Hours xx Minutes xx seconds"
         *****/
        case 0:
            
            switch HackathonStatus.current {
                
            case .beforeHackathon:
                return tableView.dequeueReusableCell(withIdentifier: "beforeHackathonCell", for: indexPath)
                
            case .beforeHacking:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beforeOrDuringHackingCell", for: indexPath)
                if let cell = cell as? HomeTableViewTitleCell {
                    cell.titleLabel?.text = "Hacking Starts in..."
                    cell.detailTimeLabel?.text = "@ Friday 10:00 pm"
                    cell.endTime = HACKING_BEGIN_TIME
                    cell.timeStart()
                }
                return cell
                
            case .duringHacking:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beforeOrDuringHackingCell", for: indexPath)
                if let cell = cell as? HomeTableViewTitleCell {
                    cell.titleLabel?.text = "Submit Projects in..."
                    cell.detailTimeLabel?.text = "@ Sunday 10:00 am"
                    cell.endTime = HACKING_END_TIME
                    cell.timeStart()
                }
                return cell
                
            case .afterHackathon:
                return tableView.dequeueReusableCell(withIdentifier: "afterHackathonCell", for: indexPath)
            }
            
        /*****
         *      The default case will be used for all other cards
         *      These cards will contain information about the events with two separate options
         *      events that have qr code scanning and events that do not
         *****/
        default:
            // check api for qr code
            let offsetIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section);
            let event = fetchedResultsController.object(at: offsetIndexPath)

            let identifier = event.locations.count > 0 ? "HomeTableViewLocationsEventCell" : "HomeTableViewEventCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
            if let cell = cell as? HomeTableViewEventCell {
                cell.delegate = self
                cell.qrButtonDelegate = self

                cell.titleLabel?.text = event.name
                cell.timeLabel?.text = HLDateFormatter.shared.string(from: event.startTime)
                
                cell.locations = event.locations.array as! [Location]
                cell.layoutIfNeeded()
            }
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showEventDetails", sender: indexPath)
    }

    // MARK: - NSFetchedResultsControllerDelegate
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        fetchRequest.includesSubentities = false
        
        // MARK: changeme
        fetchRequest.predicate = NSPredicate(format: "tag == %@", "HACKATHON")

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
        homeTableView.reloadData()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        homeTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard HackathonStatus.current == .beforeHacking || HackathonStatus.current == .duringHacking else { return }
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            homeTableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            homeTableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath, let cell = homeTableView.cellForRow(at: updateIndexPath) else { return }
            if(updateIndexPath.row <= 0) {
                return
            }
            let offsetIndexPath = IndexPath(row: updateIndexPath.row - 1, section: updateIndexPath.section);
            let event = fetchedResultsController.object(at: offsetIndexPath)

            if let cell = cell as? HomeTableViewEventCell {
                cell.titleLabel?.text = event.name
                cell.timeLabel?.text = HLDateFormatter.shared.string(from: event.startTime)
                
                cell.locations = event.locations.array as! [Location]
                cell.layoutIfNeeded()
            }

            homeTableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            homeTableView.insertRows(at: [toIndexPath],   with: .fade)
            homeTableView.deleteRows(at: [fromIndexPath], with: .fade)
        }

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard HackathonStatus.current == .beforeHacking || HackathonStatus.current == .duringHacking else { return }
        switch type {
        case .insert:
            homeTableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            homeTableView.deleteSections([sectionIndex], with: .fade)
        case .update:
            homeTableView.reloadSections([sectionIndex], with: .fade)
        case .move:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        homeTableView.endUpdates()
    }

    
    // MARK: - QRButtonDelegate
    func didTapQRButton() {
        performSegue(withIdentifier: "showQRCode", sender: nil)
    }
    
    // MARK: - LocationButtonContainerDelegate
    func locationButtonTapped(location: Location) {
        let locations: [String: Int] = [
            "DCL" : 1,
            "Digital Computer Laboratory": 1,
            "Thomas M. Siebel Center" : 2,
            "Siebel" : 2,
            "Thomas Siebel Center" : 2,
            "ECEB" : 3,
            "Electrical Computer Engineering Building" : 3,
            "Union" : 4,
            "Illini Union" : 4,
            "Kenny Gym" : 5,
            "Kenneth Gym" : 5
        ]
        
        let location_id = locations[location.shortName]
        if let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "Map") as? MapViewController {
            vc.isDirectionMode = true
            vc.directionModeLabel = location_id!
            vc.directionModeTitle = location.name
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}
