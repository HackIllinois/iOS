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

    let countdownViewController = HICountdownViewController()
    
    var staticDataStore: [(date: Date, message: String)] = [
        (HIApplication.Configuration.EVENT_START_TIME, "EVENT BEGINS IN"),
        (HIApplication.Configuration.HACKING_START_TIME, "HACKING BEGINS IN"),
        (HIApplication.Configuration.HACKING_END_TIME, "HACKING ENDS IN"),
        (HIApplication.Configuration.EVENT_END_TIME, "EVENT ENDS IN")
    ]
}

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()

        let countdownTitleLabel = UILabel()
        countdownTitleLabel.text = "HACKING ENDS IN"
        countdownTitleLabel.textColor = HIApplication.Color.darkIndigo
        countdownTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        countdownTitleLabel.textAlignment = .center
        countdownTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownTitleLabel)
        countdownTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        countdownTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        countdownTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        countdownViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(countdownViewController)
        view.addSubview(countdownViewController.view)
        countdownViewController.view.topAnchor.constraint(equalTo: countdownTitleLabel.bottomAnchor, constant: 8).isActive = true
        countdownViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        countdownViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        countdownViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        countdownViewController.didMove(toParentViewController: self)

        let happeningNowLabel = UILabel()
        happeningNowLabel.text = "HAPPENING NOW"
        happeningNowLabel.textColor = HIApplication.Color.darkIndigo
        happeningNowLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        happeningNowLabel.textAlignment = .center
        happeningNowLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(happeningNowLabel)
        happeningNowLabel.topAnchor.constraint(equalTo: countdownViewController.view.bottomAnchor, constant: 16).isActive = true
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
