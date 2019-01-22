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

        HIEventService.getAllEventsRaw(completed: {events in
            var actualEvents = [HIAPIEvent]()
            for event in events {
                let ev = HIAPIEvent(favorite: event.favorite,
                                    name: event.name,
                                    info: event.info,
                                    end: Date(timeIntervalSince1970: event.end),
                                    start: Date(timeIntervalSince1970: event.start),
                                    eventType: event.eventType,
                                    sponsor: event.sponsor,
                                    latitude: event.latitude,
                                    longitude: event.longitude)
                actualEvents.append(ev)
            }
            DispatchQueue.main.sync {
                do {
                    let ctx = CoreDataController.shared.persistentContainer.viewContext
                    try? ctx.fetch(locationsFetchRequest).forEach {
                        ctx.delete($0)
                    }
                    try? ctx.fetch(eventsFetchRequest).forEach {
                        ctx.delete($0)
                    }
                    var events = [Event]()
                    actualEvents.forEach { event in
                        events.append(Event(context: ctx, event: event, locations: NSSet()))
                    }
                    HILocalNotificationController.shared.scheduleNotifications(for: events)

                    isRefreshing = false
                }
            }
        })
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
//                var events = [Event]()
//                updatedEvents.forEach { event in
//                    let eventLocationIds = event.locations.map { Int16($0.locationId) }
//                    let eventLocations = locations.filter { eventLocationIds.contains($0.id) }
//                    events.append( Event(context: ctx, event: event, locations: NSSet(array: eventLocations)) )
//                }
//                HILocalNotificationController.shared.scheduleNotifications(for: events)

                try ctx.save()
            } catch { }
        }
    }
}
