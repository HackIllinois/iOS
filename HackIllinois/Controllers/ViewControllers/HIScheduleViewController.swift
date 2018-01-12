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

class HIScheduleViewController: HIBaseViewController {
    lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
}

// MARK: - IBActions
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let indexPath = sender as? IndexPath, let eventDetailViewController = segue.destination as? HIEventDetailViewController {
            eventDetailViewController.model = fetchedResultsController.object(at: indexPath)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // HIBaseViewController
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        setupRefreshControl()

        // UITableView
        tableView?.register(UINib(nibName: HIEventCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: HIEventCell.IDENTIFIER)
        tableView?.register(UINib(nibName: HIDateHeader.IDENTIFIER, bundle: nil), forHeaderFooterViewReuseIdentifier: HIDateHeader.IDENTIFIER)

        try! fetchedResultsController.performFetch()
    }
}

// MARK: - UITableViewDataSource
extension HIScheduleViewController {

    // FIXME: remove after finished layout debugging
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIEventCell {
            // cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "event"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HIDateHeader.IDENTIFIER)
        if let header = header as? HIDateHeader {
            header.titleLabel.text = "\(section + 1):00 PM"
        }
        return header
    }
}

// MARK: - UITableViewDelegate
extension HIScheduleViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEventDetail", sender: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UIRefreshControl
extension HIScheduleViewController {
    override func refresh(_ sender: UIRefreshControl) {
        refreshAnimation.play()
    }
}
