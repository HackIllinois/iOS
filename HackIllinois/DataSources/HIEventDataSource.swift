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
        .onCompletion { result in
            switch result {
            case .success(let containedLocations):
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
                .onCompletion { result in
                    switch result {
                    case .success(let containedEvents):
                        backgroundContext.performAndWait {
                            containedEvents.data.forEach { event in
                                let eventLocationIds = event.locations.map { Int16($0.locationId) }
                                let eventLocations = locations.filter { eventLocationIds.contains($0.id) }

                                _ = Event(context: backgroundContext, event: event, locations: NSSet(array: eventLocations))
                            }
                        }
                        try? backgroundContext.save()

                    case .cancellation, .failure:
                        break
                    }
                    completion?()
                    isRefreshing = false
                }
                .authorization(HIApplicationStateController.shared.user)
                .perform()

            case .cancellation:
                completion?()
                isRefreshing = false

            case .failure(let error):
                print(error)
                completion?()
                isRefreshing = false
            }
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }
}
