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
        tableView?.register(UINib(nibName: HIAnnouncementCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: HIAnnouncementCell.IDENTIFIER)
        
        tableView?.delegate = self
        tableView?.dataSource = self

        tableView?.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        try? _fetchedResultsController?.performFetch()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: HIAnnouncementCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIAnnouncementCell {
            //            cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "announcement"
        }
        return cell
    }
}

