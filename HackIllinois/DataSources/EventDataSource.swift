//
//  EventDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import CoreData

class EventDataSource: NSObject {

    private lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataController.shared.persistentContainer.viewContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )

        fetchedResultsController.delegate = delegate

        return fetchedResultsController
    }()

    weak var delegate: NSFetchedResultsControllerDelegate?
    let sectionNameKeyPath: String?

    init(delegate: NSFetchedResultsControllerDelegate, sectionNameKeyPath: String?) {
        self.delegate = delegate
        self.sectionNameKeyPath = sectionNameKeyPath
    }

    func update(predicate: NSPredicate?) {
        fetchedResultsController.fetchRequest.predicate = predicate
    }

    func update(sortDescriptors: [NSSortDescriptor]?) {
        fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
    }

    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }

}
