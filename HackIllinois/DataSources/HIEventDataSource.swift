//
//  HIEventDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI

final class HIEventDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshineQueue = DispatchQueue(label: "org.hackillinois.org.hi_event_data_source.is_refreshing_queue", attributes: .concurrent)
    // Tracks if the DataSource is refreshing.
    private static var _isRefreshing = false
    // Setter and getter for isRefreshing.
    public static var isRefreshing: Bool {
        get { return isRefreshineQueue.sync { _isRefreshing } }
        set { isRefreshineQueue.sync(flags: .barrier) { _isRefreshing = newValue } }
    }

    // Waive swiftlint warning
    // swiftlint:disable:next function_body_length
    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.EventService.getAllEvents()
        .onCompletion { result in
            do {
                let (containedEvents, _) = try result.get()
                HIAPI.EventService.getAllFavorites()
                .onCompletion { result in
                    do {
                        let (containedFavorites, _) = try result.get()
                        HICoreDataController.shared.performBackgroundTask { context -> Void in
                            do {
                                // 1) Unwrap contained data
                                let apiEvents = containedEvents.events
                                let apiFavorites = containedFavorites.events

                                // 2) Compute all the unique API locations.
                                let allLocations = apiEvents.flatMap { $0.locations }
                                var uniquinglocationDictionary = [String: HIAPI.Location]()
                                allLocations.forEach {
                                    uniquinglocationDictionary[$0.name] = $0
                                }
                                let uniqueLocations = Array(uniquinglocationDictionary.values)

                                // 3) Get all CoreData locations.
                                let locationFetchRequest = NSFetchRequest<Location>(entityName: "Location")
                                let coreDataLocations = try context.fetch(locationFetchRequest)

                                // 4) Diff the CoreData locations and API locations.
                                let (coreDataLocationsToDelete, coreDataLocationsToUpdate, apiLocationsToInsert)
                                    = diff(initial: coreDataLocations, final: uniqueLocations)

                                // 5) Create dictionary mapping location names to CoreData locations.
                                var coreDataLocationsDicionary = [String: Location]()

                                // 6) Apply location diff to CoreData.
                                coreDataLocationsToDelete.forEach { coreDataLocation in
                                    // Delete CoreData location.
                                    context.delete(coreDataLocation)
                                }

                                coreDataLocationsToUpdate.forEach { (coreDataLocation, apiLocation) in
                                    // Update CoreData location.
                                    coreDataLocation.latitude = apiLocation.latitude
                                    coreDataLocation.longitude = apiLocation.longitude

                                    // Add to dictionary mapping names to CoreData locations.
                                    coreDataLocationsDicionary[coreDataLocation.name] = coreDataLocation
                                }

                                apiLocationsToInsert.forEach { apiLocation in
                                    // Create CoreData location.
                                    let coreDataLocation = Location(context: context)
                                    coreDataLocation.name = apiLocation.name
                                    coreDataLocation.latitude = apiLocation.latitude
                                    coreDataLocation.longitude = apiLocation.longitude

                                    // Add to dictionary mapping names to CoreData locations.
                                    coreDataLocationsDicionary[coreDataLocation.name] = coreDataLocation
                                }

                                // 7) Get all CoreData locations.
                                let eventFetchRequest = NSFetchRequest<Event>(entityName: "Event")
                                let coreDataEvents = try context.fetch(eventFetchRequest)

                                // 8) Diff the CoreData events and API events.
                                let (
                                    coreDataEventsToDelete,
                                    coreDataEventsToUpdate,
                                    apiEventsToInsert
                                ) = diff(initial: coreDataEvents, final: apiEvents)

                                // 9) Apply the diff
                                coreDataEventsToDelete.forEach { coreDataEvent in
                                    // Delete CoreData event.
                                    context.delete(coreDataEvent)
                                }

                                coreDataEventsToUpdate.forEach { (coreDataEvent, apiEvent) in
                                    // Update CoreData event.
                                    coreDataEvent.endTime = apiEvent.endTime
                                    coreDataEvent.eventType = apiEvent.eventType
                                    coreDataEvent.info = apiEvent.info
                                    apiEvent.locations.forEach { apiLocation in
                                        guard let coreDataLocation = coreDataLocationsDicionary[apiLocation.name] else { fatalError("fuckity fuck") }
                                        coreDataEvent.addToLocations(coreDataLocation)
                                    }
                                    coreDataEvent.name = apiEvent.name
                                    coreDataEvent.sponsor = apiEvent.sponsor
                                    coreDataEvent.startTime = apiEvent.startTime
                                    coreDataEvent.favorite = apiFavorites.contains(coreDataEvent.name)
                                }

                                apiEventsToInsert.forEach { apiEvent in
                                    // Create CoreData event.
                                    let coreDataEvent = Event(context: context)
                                    coreDataEvent.endTime = apiEvent.endTime
                                    coreDataEvent.eventType = apiEvent.eventType
                                    coreDataEvent.info = apiEvent.info
                                    apiEvent.locations.forEach { apiLocation in
                                        guard let coreDataLocation = coreDataLocationsDicionary[apiLocation.name] else {
                                            fatalError("fuckity fuck")
                                        }
                                        coreDataEvent.addToLocations(coreDataLocation)
                                    }
                                    coreDataEvent.name = apiEvent.name
                                    coreDataEvent.sponsor = apiEvent.sponsor
                                    coreDataEvent.startTime = apiEvent.startTime
                                    coreDataEvent.favorite = apiFavorites.contains(coreDataEvent.name)
                                }

                                // 10) Save changes, call completion handler, unlock refresh
                                try context.save()
                                completion?()
                                isRefreshing = false
                            } catch {
                                completion?()
                                isRefreshing = false
                                print(error)
                                fatalError("fuck")
                            }
                        }
                    } catch {
                        completion?()
                        isRefreshing = false
                        print(error)
                    }
                }
                .authorize(with: HIApplicationStateController.shared.user)
                .launch()
            } catch {
                completion?()
                isRefreshing = false
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}
