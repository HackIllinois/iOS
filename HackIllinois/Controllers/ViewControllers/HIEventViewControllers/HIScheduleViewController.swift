//
//  HIScheduleViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
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
            NSSortDescriptor(key: "start", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
            NSSortDescriptor(key: "id", ascending: true)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataController.shared.persistentContainer.viewContext,
            sectionNameKeyPath: "sectionIdentifier",
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    var currentTab = 0
    var onlyFavorites = false
    let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    var dataStore = [(displayText: String, predicate: NSPredicate)]()

    // MARK: - Init
    convenience init() {
        self.init(nibName: nil, bundle: nil)

        let fridayPredicate = NSPredicate(
            format: "%@ =< start AND start < %@",
            HIConfiguration.FRIDAY_START_TIME as NSDate,
            HIConfiguration.FRIDAY_END_TIME as NSDate
        )
        dataStore.append((displayText: "FRIDAY", predicate: fridayPredicate))

        let saturdayPredicate = NSPredicate(
            format: "%@ =< start AND start < %@",
            HIConfiguration.SATURDAY_START_TIME as NSDate,
            HIConfiguration.SATURDAY_END_TIME as NSDate
        )
        dataStore.append((displayText: "SATURDAY", predicate: saturdayPredicate))

        let sundayPredicate = NSPredicate(
            format: "%@ =< start AND start < %@",
            HIConfiguration.SUNDAY_START_TIME as NSDate,
            HIConfiguration.SUNDAY_END_TIME as NSDate
        )
        dataStore.append((displayText: "SUNDAY", predicate: sundayPredicate))

        updatePredicate()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
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
        if onlyFavorites {
            sender.image = #imageLiteral(resourceName: "MenuFavorited")
        } else {
            sender.image = #imageLiteral(resourceName: "MenuUnfavorited")
        }
        updatePredicate()
        animateReload()
    }

    func updatePredicate() {
        let currentTabPredicate = dataStore[currentTab].predicate
        if onlyFavorites {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentTabPredicate, onlyFavoritesPredicate])
            fetchedResultsController.fetchRequest.predicate = compoundPredicate
        } else {
            fetchedResultsController.fetchRequest.predicate = currentTabPredicate
        }
    }

    func animateReload() {
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
    }
}

// MARK: - UIViewController
extension HIScheduleViewController {
    override func loadView() {
        super.loadView()

        let items = dataStore.map { $0.displayText }
        let segmentedControl = HISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        self.tableView = tableView
    }

    override func viewDidLoad() {
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        setupRefreshControl()
        super.viewDidLoad()
    }
}

// MARK: - UINavigationItem Setup
extension HIScheduleViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "SCHEDULE"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuUnfavorited"), style: .plain, target: self, action: #selector(didSelectFavoritesIcon(_:)))
    }
}

// MARK: - UITableViewDelegate
extension HIScheduleViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
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
        }
        return header
    }
}
