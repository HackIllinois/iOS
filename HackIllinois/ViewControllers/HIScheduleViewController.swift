//
//  HIScheduleViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData

class HIScheduleViewController: HIEventListViewController {
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
            sectionNameKeyPath: "sectionIdentifier",
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    private var dataStore: [(displayText: String, predicate: NSPredicate)] = {
        var dataStore = [(displayText: String, predicate: NSPredicate)]()
        let fridayPredicate = NSPredicate(
            format: "%@ =< startTime AND startTime < %@",
            HITimeDataSource.shared.eventTimes.fridayStart as NSDate,
            HITimeDataSource.shared.eventTimes.fridayEnd as NSDate
        )
        dataStore.append((displayText: "FRI", predicate: fridayPredicate))

        let saturdayPredicate = NSPredicate(
            format: "%@ =< startTime AND startTime < %@",
            HITimeDataSource.shared.eventTimes.saturdayStart as NSDate,
            HITimeDataSource.shared.eventTimes.saturdayEnd as NSDate
        )
        dataStore.append((displayText: "SAT", predicate: saturdayPredicate))

        let sundayPredicate = NSPredicate(
            format: "%@ =< startTime AND startTime < %@",
            HITimeDataSource.shared.eventTimes.sundayStart as NSDate,
            HITimeDataSource.shared.eventTimes.sundayEnd as NSDate
        )
        dataStore.append((displayText: "SUN", predicate: sundayPredicate))

        return dataStore
    }()

    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "PurpleBackground")
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundView.image = #imageLiteral(resourceName: "BackgroundPad")
        }
    }
}

// MARK: - Actions
extension HIScheduleViewController {
    @objc func didSelectTab(_ sender: HISegmentedControl) {
        currentTab = sender.selectedIndex
        updatePredicate()
        animateReload()
    }

    @objc func didSelectFavoritesIcon(_ sender: UIBarButtonItem) {
        onlyFavorites = !onlyFavorites
        sender.image = onlyFavorites ? #imageLiteral(resourceName: "Big Selected Bookmark") : #imageLiteral(resourceName: "Big Unselected Bookmark")
        if UIDevice.current.userInterfaceIdiom == .pad {
            sender.image = onlyFavorites ? #imageLiteral(resourceName: "FavoritedPad") : #imageLiteral(resourceName: "UnFavoritedPad")
        }
        if sender.image == #imageLiteral(resourceName: "Big Selected Bookmark") {
            super.setCustomTitle(customTitle: "SAVED EVENTS")
        } else {
            super.setCustomTitle(customTitle: "SCHEDULE")
        }
        updatePredicate()
        animateReload()
    }

    func updatePredicate() {
        fetchedResultsController.fetchRequest.predicate = currentPredicate()
    }

    func currentPredicate() -> NSPredicate {
        let currentTabPredicate = dataStore[currentTab].predicate
        if onlyFavorites {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentTabPredicate, onlyFavoritesPredicate])
            return compoundPredicate
        } else {
            return currentTabPredicate
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
extension HIScheduleViewController {
    override func loadView() {
        super.loadView()

        let items = dataStore.map { $0.displayText }
        let segmentedControl = HIScheduleSegmentedControl(titles: items, nums: [23, 24, 25])
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        var segmentedControlConstant: CGFloat = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            segmentedControlConstant = 40.0
        }

        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 + segmentedControlConstant).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -50).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 34).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 66 + segmentedControlConstant).isActive = true
        
        // Start the segmented control on the current day
        let now = Date()
        if now > HITimeDataSource.shared.eventTimes.sundayStart {
            segmentedControl.selectedIndex = 2
        }
        else if now > HITimeDataSource.shared.eventTimes.saturdayStart {
            segmentedControl.selectedIndex = 1
        }
        
        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0)
        self.tableView = tableView
        
        tableView.addLeftAndRightSwipeGestureRecognizers(
            target: segmentedControl,
            selector: #selector(segmentedControl.handleSwipeGesture(_:))
        )
    }

    override func viewDidLoad() {
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        setupRefreshControl()
        super.viewDidLoad()
        guard let user = HIApplicationStateController.shared.user else { return }
        if !user.roles.contains(.STAFF) {
            super.setCustomTitle(customTitle: "SCHEDULE")
        } else {
            setStaffShiftsControl()
        }
    }
}

// MARK: - Staff Shifts Control Setup
extension HIScheduleViewController {
    @objc func setStaffShiftsControl() {
        let scheduleLabel = HILabel(style: .viewTitle)
        scheduleLabel.text = "SCHEDULE"

        let scheduleView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
        scheduleView.addSubview(scheduleLabel)

        // Add invisible buttons over the custom views
        let scheduleButton = createInvisibleButton(withTarget: self, action: #selector(scheduleButtonTapped(_:)))
        scheduleButton.frame = scheduleView.bounds
        scheduleView.addSubview(scheduleButton)
        let shiftsButton = createInvisibleButton(withTarget: self, action: #selector(shiftsButtonTapped(_:)))
        shiftsButton.frame = CGRect(x: view.bounds.width - 120, y: 70, width: 160, height: 30)
        view.addSubview(shiftsButton)
        // Set the leftBarButtonItem and rightBarButtonItem
        let scheduleBarButtonItem = UIBarButtonItem(customView: scheduleView)
        let shiftsLabel = HILabel(style: .viewTitle)
        shiftsLabel.text = "SHIFTS"
        shiftsButton.addSubview(shiftsLabel)
        self.navigationItem.leftBarButtonItem = scheduleBarButtonItem
        //self.navigationItem.rightBarButtonItem = shiftsBarButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    // Helper method to create invisible buttons
    private func createInvisibleButton(withTarget target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    // Actions for left and right buttons
    @objc func scheduleButtonTapped(_ sender: UIButton) {
        print("Schedule button tapped")
        // Handle left button tap
    }

    @objc func shiftsButtonTapped(_ sender: UIButton) {
        print("Shifts button tapped")
        // Handle right button tap
    }
}



// MARK: - UINavigationItem Setup
extension HIScheduleViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        if !HIApplicationStateController.shared.isGuest {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuUnfavorited"), style: .plain, target: self, action: #selector(didSelectFavoritesIcon(_:)))
            if UIDevice.current.userInterfaceIdiom == .pad {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UnFavoritedPad"), style: .plain, target: self, action: #selector(didSelectFavoritesIcon(_:)))
            }
        }
    }

    override func didMove(toParent parent: UIViewController?) {
        if let navController = navigationController as? HINavigationController {
            navController.infoTitleIsHidden = false
        }
    }
}

// MARK: - UITabBarItem Setup
extension HIScheduleViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "schedule"), selectedImage: #imageLiteral(resourceName: "ScheduleSelected"))
    }
}

// MARK: - UITableViewDelegate
extension HIScheduleViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 60
        } else {
            return 30 // Changes height between event cells
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }
}

// MARK: - UITableViewDataSource
extension HIScheduleViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HIDateHeader.identifier)
        if let header = header as? HIDateHeader,
            let sections = fetchedResultsController.sections,
            section < sections.count,
            let date = Formatter.coreData.date(from: sections[section].name) {
            header.titleLabel.text = Formatter.simpleTime.string(from: date)
            header.titleLabel.textColor <- \.white
            header.titleLabel.textAlignment = .center
            if UIDevice.current.userInterfaceIdiom == .pad {
                header.titleLabel.font = HIAppearance.Font.timeIndicator
            } else {
                header.titleLabel.font = HIAppearance.Font.dateHeader
            }

        }
        return header
    }
}
