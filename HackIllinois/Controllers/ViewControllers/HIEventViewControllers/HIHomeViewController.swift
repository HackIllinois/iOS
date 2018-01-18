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
        // FIXME: add predicate for current hour +- 1
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
}

// MARK: - UIViewController
extension HIHomeViewController {
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
