//
//  HICoreDataController.swift
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
import CoreData

class HICoreDataController {

    static let shared = HICoreDataController()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HackIllinois")
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        // could be set to true and hidden behind the launching animation + a loading screen if needed
        container.persistentStoreDescriptions.first?.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions.first?.isReadOnly = false
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                container.viewContext.automaticallyMergesChangesFromParent = true
            }
        }
        return container
    }()

    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public func newPrivateContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    public func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }

    public func purge() {
        performBackgroundTask { context in
            ["Announcement", "Event", "Project"].forEach { entity in
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
                do {
                    try context.execute(batchDelete)
                } catch {
                    print(error)
                }
            }

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
