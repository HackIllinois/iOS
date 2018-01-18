//
//  HIAnnouncmentsViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIAnnouncmentsViewController: HIBaseViewController {
    // MARK - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Announcement> = {
        let fetchRequest: NSFetchRequest<Announcement> = Announcement.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
}

// MARK: - Actions
extension HIAnnouncmentsViewController {

}

// MARK: - UIViewController
extension HIAnnouncmentsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        try? _fetchedResultsController?.performFetch()
    }
}

// MARK: - UITableView Setup
extension HIAnnouncmentsViewController {
    override func setupTableView() {
        tableView?.register(UINib(nibName: HIAnnouncementCell.storyboardIdentifier, bundle: nil), forCellReuseIdentifier: HIAnnouncementCell.storyboardIdentifier)
        super.setupTableView()
    }
}

// MARK: - UINavigationItem Setup
extension HIAnnouncmentsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "NOTIFICATIONS"
    }
}

// MARK: - UITableViewDataSource
extension HIAnnouncmentsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIAnnouncementCell.storyboardIdentifier, for: indexPath)
        if let cell = cell as? HIAnnouncementCell {
            //            cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "announcement"
        }
        return cell
    }
}

