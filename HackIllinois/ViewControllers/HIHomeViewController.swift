//
//  HIHomeViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/12/18.
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
            NSSortDescriptor(key: "startTime", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
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

    private var currentTab = 0

    private var dataStore: [(displayText: String, predicate: NSPredicate)] = {
        var dataStore = [(displayText: String, predicate: NSPredicate)]()
        let happeningNowPredicate = NSPredicate(format: "(startTime < now()) AND (endTime > now())")
        dataStore.append((displayText: "HAPPENING NOW ", predicate: happeningNowPredicate))

        let inFifteenMinutes = Date(timeIntervalSinceNow: 900)
        let upcomingPredicate = NSPredicate(format: "(startTime < %@) AND (startTime > now())", inFifteenMinutes as NSDate)
        dataStore.append((displayText: "UPCOMING", predicate: upcomingPredicate))

        return dataStore
    }()

    private let countdownTitleLabel = HILabel(style: .title)
    private lazy var countdownViewController = HICountdownViewController(delegate: self)
    private let happeningNowLabel = HILabel(style: .title) {
        $0.text = "HAPPENING NOW"
    }

    private var countdownDataStoreIndex = 0
    private var staticDataStore: [(date: Date, displayText: String)] = [
        (HITimeDataSource.shared.eventTimes.eventStart, "HACKILLINOIS BEGINS IN"),
        (HITimeDataSource.shared.eventTimes.hackStart, "HACKING BEGINS IN"),
        (HITimeDataSource.shared.eventTimes.hackEnd, "HACKING ENDS IN"),
        (HITimeDataSource.shared.eventTimes.eventEnd, "HACKILLINOIS ENDS IN")
    ]

    private var timer: Timer?
}

// MARK: - Actions
extension HIHomeViewController {
    @objc func didSelectTab(_ sender: HISegmentedControl) {
        currentTab = sender.selectedIndex
        updatePredicate()
        animateReload()
    }

    func updatePredicate() {
        fetchedResultsController.fetchRequest.predicate = currentPredicate()
    }

    func currentPredicate() -> NSPredicate {
        return dataStore[currentTab].predicate
    }

    func animateReload() {
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
    }
}

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(countdownTitleLabel)
        countdownTitleLabel.constrain(to: view.safeAreaLayoutGuide, topInset: 20, trailingInset: 0, leadingInset: 0)

        countdownViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(countdownViewController)
        view.addSubview(countdownViewController.view)
        countdownViewController.view.topAnchor.constraint(equalTo: countdownTitleLabel.bottomAnchor, constant: 8).isActive = true
        countdownViewController.view.constrain(to: view.safeAreaLayoutGuide, trailingInset: -20, leadingInset: 20)
        countdownViewController.view.constrain(height: 150)
        countdownViewController.didMove(toParent: self)

        let items = dataStore.map { $0.displayText }
        let segmentedControl = HISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: countdownViewController.view.bottomAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
        tableView.constrain(to: view.safeAreaLayoutGuide, trailingInset: 0, leadingInset: 0)
        tableView.constrain(to: view, bottomInset: 0)
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

// MARK: - UITabBarItem Setup
extension HIHomeViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), tag: 0)
    }
}

// MARK: - Actions
extension HIHomeViewController {
    @objc func presentIndoorMapsViewController() {
        let popupView = HIPopupController()
        popupView.modalPresentationStyle = .overCurrentContext
        popupView.transitioningDelegate = popupView
        self.present(popupView, animated: true)
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
        updatePredicate()
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
    }

    func teardownPredicateRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }
}
