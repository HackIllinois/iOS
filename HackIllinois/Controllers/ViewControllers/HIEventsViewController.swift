//
//  HIEventsViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIEventsViewController: HIBaseViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
        ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    @IBAction func launchGet() {
        HIAnnouncementService.getAllAnnouncements()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)

        HIEventService.getAllEvents()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)

        HIEventService.getAllLocations()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        tableView?.dataSource = self
    }

}

extension HIEventsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).name
        return cell
    }
}
