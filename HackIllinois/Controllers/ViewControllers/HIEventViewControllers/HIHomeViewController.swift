//
//  HIHomeViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIHomeViewController: HIEventListViewController {
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "start", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
            NSSortDescriptor(key: "id", ascending: true)
        ]

        // TODO: maybe extend start to be a bit before now() such that events that begin shortly are included in this view
        fetchRequest.predicate = NSPredicate(format: "(start < now()) AND (end > now())")

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

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()

        let hackingEndsInLabel = UILabel()
        hackingEndsInLabel.text = "HACKING ENDS IN"
        hackingEndsInLabel.textColor = HIColor.darkIndigo
        hackingEndsInLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        hackingEndsInLabel.textAlignment = .center
        hackingEndsInLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hackingEndsInLabel)
        hackingEndsInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        hackingEndsInLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        hackingEndsInLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        let countdownContainerView = UIView()
        // TODO: remove background color after view debugging
        countdownContainerView.backgroundColor = HIColor.hotPink
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownContainerView)
        countdownContainerView.topAnchor.constraint(equalTo: hackingEndsInLabel.bottomAnchor, constant: 15).isActive = true
        countdownContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        countdownContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        countdownContainerView.heightAnchor.constraint(equalToConstant: 188).isActive = true

        let happeningNowLabel = UILabel()
        happeningNowLabel.text = "HAPPENING NOW"
        happeningNowLabel.textColor = HIColor.darkIndigo
        happeningNowLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        happeningNowLabel.textAlignment = .center
        happeningNowLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(happeningNowLabel)
        happeningNowLabel.topAnchor.constraint(equalTo: countdownContainerView.bottomAnchor, constant: 15).isActive = true
        happeningNowLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        happeningNowLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: happeningNowLabel.bottomAnchor, constant: 5).isActive = true
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
extension HIHomeViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "HOME"
    }
}
