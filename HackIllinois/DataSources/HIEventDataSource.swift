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

final class HIEventDataSource {

    static var isRefreshing = false

    static let locationsFetchRequest = NSFetchRequest<Location>(entityName: "Location")
    static let eventsFetchRequest = NSFetchRequest<Event>(entityName: "Event")

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIEventService.getAllLocations()
        .onCompletion { result in
            if case let .success(containedLocations) = result {
                print("GET::LOCATIONS::SUCCESS")
                HIEventService.getAllEvents()
                .onCompletion { result in
                    if case let .success(containedEvents) = result {
                        print("GET::EVENTS::SUCCESS")
                        HIEventService.getAllFavorites()
                        .onCompletion { result in
                            if case let .success(containedFavorites) = result {
                                print("GET::FAVORITES::SUCCESS")

                                var updatedEvents = [HIAPIEvent]()
                                containedEvents.data.forEach { event in
                                    var event = event
                                    event.favorite = containedFavorites.data.map { $0.eventId }.contains(event.id)
                                    updatedEvents.append(event)
                                }
                                setEventNotifications(containedLocations: containedLocations, updatedEvents: updatedEvents)
                            }
                            completion?()
                            isRefreshing = false
                        }
                        .authorization(HIApplicationStateController.shared.user)
                        .perform()
                    } else {
                        completion?()
                        isRefreshing = false
                    }
                }
                .authorization(HIApplicationStateController.shared.user)
                .perform()
            } else {
                completion?()
                isRefreshing = false
            }
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }

    static private func setEventNotifications(containedLocations: HIAPILocation.Contained,
                                              updatedEvents: [HIAPIEvent]) {
        DispatchQueue.main.sync {
            do {
                let ctx = CoreDataController.shared.persistentContainer.viewContext
                try? ctx.fetch(locationsFetchRequest).forEach {
                    ctx.delete($0)
                }
                try? ctx.fetch(eventsFetchRequest).forEach {
                    ctx.delete($0)
                }
                var locations = [Location]()
                containedLocations.data.forEach { location in
                    locations.append( Location(context: ctx, location: location) )
                }
                var events = [Event]()
                updatedEvents.forEach { event in
                    let eventLocationIds = event.locations.map { Int16($0.locationId) }
                    let eventLocations = locations.filter { eventLocationIds.contains($0.id) }
                    events.append( Event(context: ctx, event: event, locations: NSSet(array: eventLocations)) )
                }
                HILocalNotificationController.shared.scheduleNotifications(for: events)

                try ctx.save()
            } catch { }
        }
    }
}
