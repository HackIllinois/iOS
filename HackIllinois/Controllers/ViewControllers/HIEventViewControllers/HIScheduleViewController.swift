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
    override func loadView() {
        super.loadView()
        
        let segmentedControl = HISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.tableView = tableView
    }
    
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

// MARK: - UITableViewDelegate
extension HIEventListViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}





