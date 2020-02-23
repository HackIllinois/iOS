//
//  HIAnnouncementsViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import HIAPI

class HIAnnouncementsViewController: HIBaseViewController {
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Announcement> = {
        let fetchRequest: NSFetchRequest<Announcement> = Announcement.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "time", ascending: false),
            NSSortDescriptor(key: "title", ascending: true)
        ]

        fetchRequest.predicate = currentPredicate()

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: HICoreDataController.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    var adminAnnouncementViewController = HIAdminAnnouncementViewController()
}

// MARK: - UIViewController
extension HIAnnouncementsViewController {
    override func loadView() {
        super.loadView()

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        try? fetchedResultsController.performFetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HIAnnouncementDataSource.refresh()

        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        var rightNavigationItem: UIBarButtonItem?
        if HIApplicationStateController.shared.user?.roles.contains(.admin) == true {
            rightNavigationItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAdminAnnouncementViewController))
        }
        navigationItem.rightBarButtonItem = rightNavigationItem
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func viewWillEnterForeground() {
        try? fetchedResultsController.performFetch()
        HIAnnouncementDataSource.refresh()
    }
}

// MARK: - Actions
extension HIAnnouncementsViewController {
    @objc func presentAdminAnnouncementViewController() {
        navigationController?.pushViewController(adminAnnouncementViewController, animated: true)
    }

    func currentPredicate() -> NSPredicate {
        let roles = HIApplicationStateController.shared.user?.roles ?? .null
        return NSPredicate(format: "(\(roles.rawValue)) > 0")
    }
}

// MARK: - UITableView Setup
extension HIAnnouncementsViewController {
    override func setupTableView() {
        tableView?.register(HIAnnouncementCell.self, forCellReuseIdentifier: HIAnnouncementCell.identifier)
        super.setupTableView()
    }
}

// MARK: - UINavigationItem Setup
extension HIAnnouncementsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "ANNOUNCEMENTS"
    }
}

// MARK: - UITableViewDataSource
extension HIAnnouncementsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIAnnouncementCell.identifier, for: indexPath)
        if let cell = cell as? HIAnnouncementCell {
            let announcement = fetchedResultsController.object(at: indexPath)
            cell <- announcement
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIAnnouncementsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIAnnouncementsViewController {
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        HIAnnouncementDataSource.refresh(completion: endRefreshing)
    }
}
