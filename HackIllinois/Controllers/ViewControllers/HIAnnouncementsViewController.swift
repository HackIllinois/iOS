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

class HIAnnouncementsViewController: HIBaseViewController {
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Announcement> = {
        let fetchRequest: NSFetchRequest<Announcement> = Announcement.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataController.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

}

// MARK: - Actions
extension HIAnnouncementsViewController {

}

// MARK: - UIViewController
extension HIAnnouncementsViewController {
    override func loadView() {
        super.loadView()

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.estimatedRowHeight = 100
        self.tableView = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()

        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>

        try? _fetchedResultsController?.performFetch()
    }

}

// MARK: - UITableView Setup
extension HIAnnouncementsViewController {
    override func setupTableView() {
        tableView?.register(HIAnnouncementCell.self, forCellReuseIdentifier: HIAnnouncementCell.IDENTIFIER)
        super.setupTableView()
    }
}

// MARK: - UINavigationItem Setup
extension HIAnnouncementsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "NOTIFICATIONS"
    }
}

// MARK: - UITableViewDataSource
extension HIAnnouncementsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIAnnouncementCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIAnnouncementCell {
            let announcement = fetchedResultsController.object(at: indexPath)
            cell <- announcement
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIAnnouncementsViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let announcement = fetchedResultsController.object(at: indexPath)
        return HIAnnouncementCell.heightForCell(with: announcement)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIAnnouncementsViewController {
    override func refresh(_ sender: UIRefreshControl) {
        refreshAnimation.play()
        HIAnnouncementDataSource.refresh(completion: endRefreshing)
    }
}
