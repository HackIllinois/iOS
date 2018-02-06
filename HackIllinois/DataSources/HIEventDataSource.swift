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

        HIEventService.getAllLocations()
        .onCompletion { result in
            switch result {
            case .success(let containedLocations):

                HIEventService.getAllEvents()
                .onCompletion { result in
                    if case let .success(containedEvents) = result {
                        DispatchQueue.main.sync {
                            do {
                                let ctx = CoreDataController.shared.persistentContainer.viewContext
                                var locations = [Location]()
                                containedLocations.data.forEach { location in
                                    locations.append( Location(context: ctx, location: location) )
                                }
                                containedEvents.data.forEach { event in
                                    let eventLocationIds = event.locations.map { Int16($0.locationId) }
                                    let eventLocations = locations.filter { eventLocationIds.contains($0.id) }
                                    _ = Event(context: ctx, event: event, locations: NSSet(array: eventLocations))
                                }
                                try ctx.save()
                            } catch { }
                        }
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
