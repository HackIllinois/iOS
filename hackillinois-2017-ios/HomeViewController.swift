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
            // TODO: change me
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
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let events = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
        switch HackathonStatus.current {
        case .beforeHackathon, .afterHackathon:
            return 1
        case .beforeHacking, .duringHacking:
            return events + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let offsetIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        performSegue(withIdentifier: "showEventDetails", sender: fetchedResultsController.object(at: offsetIndexPath))
    }

    // MARK: - NSFetchedResultsControllerDelegate
    override func predicate() -> NSPredicate? {
        return NSPredicate(format: "tag == %@", "HACKATHON")
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard HackathonStatus.current == .beforeHacking || HackathonStatus.current == .duringHacking else { return }
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath, let cell = tableView.cellForRow(at: updateIndexPath) else { return }
            if (updateIndexPath.row <= 0) {
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
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [toIndexPath],   with: .fade)
            tableView.deleteRows(at: [fromIndexPath], with: .fade)
        }

        super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard HackathonStatus.current == .beforeHacking || HackathonStatus.current == .duringHacking else { return }
        super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
    }
    
    // MARK: - QRButtonDelegate
    func didTapQRButton() {
        performSegue(withIdentifier: "showQRCode", sender: nil)
    }
}
