//
//  HIScheduleViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIScheduleViewController: HIEventListViewController {
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
}

// MARK: - Actions
extension HIScheduleViewController {
    @IBAction func launchGet() {
        HIAnnouncementService.getAllAnnouncements()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform()

        HIEventService.getAllEvents()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform()

        HIEventService.getAllLocations()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform()
    }
}

// MARK: - UIViewController
extension HIScheduleViewController {
    override func viewDidLoad() {
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        super.viewDidLoad()
    }
}

// MARK: - UINavigationItem Setup
extension HIScheduleViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "SCHEDULE"
    }
}
