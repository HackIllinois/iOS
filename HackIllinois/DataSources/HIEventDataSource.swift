//
//  HIEventDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import CoreData

final class HIEventDataSource {

    static var isRefreshing = false

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        HIEventService.getAllLocations()
        .onSuccess { (containedLocations) in
            // TODO: only remove all events/locations
            backgroundContext.reset()

            var locations = [Location]()
            backgroundContext.performAndWait {
                containedLocations.data.forEach { location in
                    locations.append(
                        Location(context: backgroundContext, location: location)
                    )
                }
            }

            HIEventService.getAllEvents()
            .onSuccess { (containedEvents) in

                backgroundContext.performAndWait {
                    containedEvents.data.forEach { event in
                        let eventLocationIds = event.locations.map { Int16($0.locationId) }
                        let eventLocations = locations.filter { eventLocationIds.contains($0.id) }

                        _ = Event(context: backgroundContext, event: event, locations: NSSet(array: eventLocations))
                    }
                }
                try? backgroundContext.save()

                completion?()
                isRefreshing = false
            }
            .onFailure { _ in
                completion?()
                isRefreshing = false
            }
            .perform()
        }
        .onFailure { error in
            print(error)
            completion?()
            isRefreshing = false
        }
        .perform()
    }
}
