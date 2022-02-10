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
import PassKit
import os
import HIAPI

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

    private var dataStore: [String] = ["Ongoing", "Upcoming"]

    private lazy var countdownViewController = HICountdownViewController(delegate: self)
    private let countdownFrameView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let viewImage = #imageLiteral(resourceName: "Chicken")
        $0.layer.contents = viewImage.cgImage
    }

    private var countdownDataStoreIndex = 0
    private var staticDataStore: [(date: Date, displayText: String)] = [
        (HITimeDataSource.shared.eventTimes.eventStart, "HackIllinois Begins In"),
        (HITimeDataSource.shared.eventTimes.hackStart, "Hacking Begins In"),
        (HITimeDataSource.shared.eventTimes.hackEnd, "Hacking Ends In"),
        (HITimeDataSource.shared.eventTimes.eventEnd, "HackIllinois Ends In")
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
        if currentTab == 0 {
            return NSPredicate(format: "(startTime < now()) AND (endTime > now())")
        } else {
            let inTwoHours = Date(timeIntervalSinceNow: 7200)
            let upcomingPredicate = NSPredicate(format: "(startTime < %@) AND (startTime > now())", inTwoHours as NSDate)
            return upcomingPredicate
        }
    }

    func animateReload() {
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
        if let tableView = tableView, !tableView.visibleCells.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(countdownFrameView)
        countdownFrameView.translatesAutoresizingMaskIntoConstraints = false
        countdownFrameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        countdownFrameView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        var countdownFrameConstant: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            countdownFrameConstant = 1.2
        } else if UIScreen.main.bounds.width < 375.0 {
            countdownFrameConstant = 0.9
        }
        let widthConstant: CGFloat = 329 * countdownFrameConstant
        let heightConstant: CGFloat = 283 * countdownFrameConstant
        countdownFrameView.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        countdownFrameView.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true

        countdownViewController.view.translatesAutoresizingMaskIntoConstraints = false
        countdownFrameView.addSubview(countdownViewController.view)
        countdownViewController.view.topAnchor.constraint(equalTo: countdownFrameView.centerYAnchor, constant: 10).isActive = true
        countdownViewController.view.heightAnchor.constraint(equalTo: countdownFrameView.heightAnchor, multiplier: 0.3).isActive = true
        countdownViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        countdownViewController.didMove(toParent: self)

        let items = dataStore.map { $0 }
        let segmentedControl = HIHomeSegmentedControl(status: items)
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: countdownFrameView.bottomAnchor, constant: 20).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor <- \.clear
        self.view.addSubview(separator)
        separator.constrain(height: 1 / (UIScreen.main.scale))
        separator.constrain(to: view, trailingInset: 0, leadingInset: 0)
        separator.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10).isActive = true
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
        setupPass()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        teardownPredicateRefreshTimer()
    }
}

// MARK: - UIImageView Setup
extension HIHomeViewController {
    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "ScheduleBackground")
    }
}

// MARK: - UITabBarItem Setup
extension HIHomeViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "HomeSelected"))
    }
}

// MARK: - Actions
extension HIHomeViewController: HICountdownViewControllerDelegate {
    func countdownToDateFor(countdownViewController: HICountdownViewController) -> Date? {
        let now = Date()
        while countdownDataStoreIndex < staticDataStore.count {
            let currDate = staticDataStore[countdownDataStoreIndex].date
            let displayText = staticDataStore[countdownDataStoreIndex].displayText
            if currDate > now {
                super.setCustomTitle(customTitle: displayText)
                return currDate
            } else {
                super.setCustomTitle(customTitle: "What's Cooking?")
            }
            countdownDataStoreIndex += 1
        }
        return nil
    }
}

// MARK: - Pass/Wallet setup
extension HIHomeViewController {
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
            let user = HIApplicationStateController.shared.user,
            !HIApplicationStateController.shared.isGuest,
            let url = user.qrURL,
            !UserDefaults.standard.bool(forKey: HIConstants.PASS_PROMPTED_KEY(user: user)) else { return }
        HIAPI.PassService.getPass(qr: url.absoluteString, identifier: user.email)
        .onCompletion { result in
            do {
                let (data, _) = try result.get()
                let pass = try PKPass(data: data)
                guard let passVC = PKAddPassesViewController(pass: pass) else {
                    throw HIError.passbookError
                }
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        UserDefaults.standard.set(true, forKey: HIConstants.PASS_PROMPTED_KEY(user: user))
                        strongSelf.present(passVC, animated: true, completion: nil)
                    }
                }
            } catch {
                os_log(
                    "Error initializing PKPass: %s",
                    log: Logger.ui,
                    type: .error,
                    String(describing: error)
                )
            }
        }
        .launch()
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
