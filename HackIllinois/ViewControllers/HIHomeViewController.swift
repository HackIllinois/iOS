//
//  HIHomeViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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

        fetchRequest.predicate = NSPredicate(format: "(start < now()) AND (end > now())")

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: HICoreDataController.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    let countdownTitleLabel = HILabel(style: .title)
    lazy var countdownViewController = HICountdownViewController(delegate: self)

    var countdownDataStoreIndex = 0
    var staticDataStore: [(date: Date, displayText: String)] = [
        (HIConstants.EVENT_START_TIME, "HACKILLINOIS BEGINS IN"),
        (HIConstants.HACKING_START_TIME, "HACKING BEGINS IN"),
        (HIConstants.HACKING_END_TIME, "HACKING ENDS IN"),
        (HIConstants.EVENT_END_TIME, "HACKILLINOIS ENDS IN")
    ]

    var timer: Timer?
}

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()

        countdownTitleLabel.text = "HACKING ENDS IN"
        view.addSubview(countdownTitleLabel)
        countdownTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        countdownTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        countdownTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        countdownViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(countdownViewController)
        view.addSubview(countdownViewController.view)
        countdownViewController.view.topAnchor.constraint(equalTo: countdownTitleLabel.bottomAnchor, constant: 8).isActive = true
        countdownViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        countdownViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        countdownViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        countdownViewController.didMove(toParent: self)

        let happeningNowLabel = HILabel(style: .title)
        happeningNowLabel.text = "HAPPENING NOW"
        view.addSubview(happeningNowLabel)
        happeningNowLabel.topAnchor.constraint(equalTo: countdownViewController.view.bottomAnchor, constant: 16).isActive = true
        happeningNowLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        happeningNowLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        let tableView = HITableView()
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
        setupRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPredicateRefreshTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        teardownPredicateRefreshTimer()
    }
}

// MARK: - UINavigationItem Setup
extension HIHomeViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "HOME"
    }
}

extension HIHomeViewController: HICountdownViewControllerDelegate {
    func countdownToDateFor(countdownViewController: HICountdownViewController) -> Date? {
        let now = Date()
        while countdownDataStoreIndex < staticDataStore.count {
            let currDate = staticDataStore[countdownDataStoreIndex].date
            if currDate > now {
                countdownTitleLabel.text = staticDataStore[countdownDataStoreIndex].displayText
                return currDate
            }
            countdownDataStoreIndex += 1
        }
        return nil
    }
}

extension HIHomeViewController {
    func setupPredicateRefreshTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(refreshPredicate),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func refreshPredicate() {
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
    }

    func teardownPredicateRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }
}
