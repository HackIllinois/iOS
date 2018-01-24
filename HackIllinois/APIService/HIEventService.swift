//
//  HIEventService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager
import CoreData

class HIEventService: HIBaseService {
    override class var baseURL: String {
        return super.baseURL + "/event"
    }

    // MARK: Events
    class func create(event: HIAPIEvent) -> APIRequest<HIAPIEvent.Contained> {
        let eventDict = [String: Any]()
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    class func getAllEvents(active: Bool = false) -> APIRequest<HIAPIEvent.Contained> {
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", params: ["active": "\(active)"], method: .GET)
    }

    // MARK: Locations
    class func create(location: HIAPILocation) -> APIRequest<HIAPILocation.Contained> {
        let locationDict = [String: Any]()
        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location", body: locationDict, method: .POST)
    }

    class func getAllLocations() -> APIRequest<HIAPILocation.Contained> {
        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location/all", method: .GET)
    }

    // TODO: move into somthing like EventDataSource
    // add a bool isRefreshing to ensure multiple refreshes are not requested
    class func refreshEvents(completion: (() -> Void)? = nil) {
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        HIEventService.getAllLocations()
        .onSuccess { (containedLocations) in
            backgroundContext.reset()

            var locations = [Location]()
            backgroundContext.performAndWait {
                for location in containedLocations.data {
                    locations.append(
                        Location(context: backgroundContext, location: location)
                    )
                }
            }

            DispatchQueue.main.async {
                HIEventService.getAllEvents()
                .onSuccess { (containedEvents) in

                    backgroundContext.performAndWait {
                        for event in containedEvents.data {
                            let eventLocationIds = event.locations.map { Int16($0.locationId) }
                            let eventLocations = locations.filter { eventLocationIds.contains($0.id) }

                            _ = Event(context: backgroundContext, event: event, locations: NSSet(array: eventLocations))
                        }
                        try? backgroundContext.save()
                    }
                    completion?()
                }
                .onFailure { _ in
                    completion?()
                }
                .perform()
            }
        }
        .onFailure { error in
            print(error)
            completion?()
        }
        .perform()

    }
}
