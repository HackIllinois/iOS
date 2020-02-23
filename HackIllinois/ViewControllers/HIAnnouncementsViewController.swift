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
    private let closeButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "MenuClose")
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
    }
    private let titleLabel = HILabel(style: .detailTitle) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.detailTitle
    }
}

// MARK: - UIViewController
extension HIAnnouncementsViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        closeButton.constrain(height: 20)

        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 35).isActive = true

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6).isActive = true
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
        titleLabel.text = "ANNOUNCEMENTS"
        HIAnnouncementDataSource.refresh()

        var rightNavigationItem: UIBarButtonItem?
        if HIApplicationStateController.shared.user?.roles.contains(.admin) == true {
            rightNavigationItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAdminAnnouncementViewController))
        }
        navigationItem.rightBarButtonItem = rightNavigationItem
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

    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
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
