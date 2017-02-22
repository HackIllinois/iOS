//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: BaseNSFetchedResultsTableViewController, QRButtonDelegate {
    
    // MARK: - Enums
    enum HackathonStatus {
        case beforeHackathon
        case beforeHacking
        case duringHacking
        case afterHackathon
        
        static var current: HackathonStatus {
            let time = Date()
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
    
    
    // MARK: - IBAction
    var showAll = false
    @IBAction func filter() {
        let alert = UIAlertController(title: "Filter Events", message: nil, preferredStyle: .actionSheet)
        let allAction = UIAlertAction(title: "All", style: .default) { (_) in
            self.showAll = true
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.fetch()
        }
        let upcomingAction = UIAlertAction(title: "Upcoming", style: .default) { (_) in
            self.showAll = false
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.fetch()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(allAction)
        alert.addAction(upcomingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch HackathonStatus.current {
        case .beforeHackathon, .afterHackathon:
            return 1
        case .beforeHacking, .duringHacking:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            switch HackathonStatus.current {
            case .beforeHackathon, .afterHackathon:
                return 0
            case .beforeHacking, .duringHacking:
                return fetchedResultsController.sections?[0].numberOfObjects ?? 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        
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
                    cell.eventsTitleLabel?.text = showAll ? "All Events" : "Upcoming"
                    cell.timeStart()
                }
                return cell
                
            case .duringHacking:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beforeOrDuringHackingCell", for: indexPath)
                if let cell = cell as? HomeTableViewTitleCell {
                    cell.titleLabel?.text = "Submit Projects in..."
                    cell.detailTimeLabel?.text = "@ Sunday 10:00 am"
                    cell.endTime = HACKING_END_TIME
                    cell.eventsTitleLabel?.text = showAll ? "All Events" : "Upcoming"
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
            let event = fetchedResultsController.sections?[0].objects?[indexPath.row] as! Feed

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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        performSegue(withIdentifier: "showEventDetails", sender: fetchedResultsController.sections?[0].objects?[indexPath.row])
    }

    // MARK: - NSFetchedResultsControllerDelegate
    override func predicate() -> NSPredicate? {
        if showAll {
            return NSPredicate(format: "tag == %@", "SCHEDULE")
        } else {
            return NSPredicate(format: "tag == %@ AND (startTime >= %@)", "SCHEDULE", NSDate(timeInterval: -1 * 60 * 60, since: Date()))
        }
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard HackathonStatus.current == .beforeHacking || HackathonStatus.current == .duringHacking else { return }
        
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            let offsetIndexPath = IndexPath(row: insertIndexPath.row, section: insertIndexPath.section + 1)
            tableView.insertRows(at: [offsetIndexPath], with: .fade)
            
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            let offsetIndexPath = IndexPath(row: deleteIndexPath.row, section: deleteIndexPath.section + 1)
            tableView.deleteRows(at: [offsetIndexPath], with: .fade)
            
        case .update:
            break
            
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            let offsetIndexPath1 = IndexPath(row: fromIndexPath.row, section: fromIndexPath.section + 1)
            let offsetIndexPath2 = IndexPath(row: toIndexPath.row, section: toIndexPath.section + 1)
            tableView.moveRow(at: offsetIndexPath1, to: offsetIndexPath2)
        }
        
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
    }
    
    // MARK: - QRButtonDelegate
    func didTapQRButton() {
        performSegue(withIdentifier: "showQRCode", sender: nil)
    }
}
