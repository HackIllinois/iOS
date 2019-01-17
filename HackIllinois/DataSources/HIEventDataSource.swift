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

    static var isRefreshing = false

    static let locationsFetchRequest = NSFetchRequest<Location>(entityName: "Location")
    static let eventsFetchRequest = NSFetchRequest<Event>(entityName: "Event")

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.EventService.getAllEvents()
            .onCompletion { result in
                switch result {
                case .success(let containedEvents, _):
                    HIAPI.EventService.getAllFavorites()
                        .onCompletion { result in
                            switch result {
                            case .success(let containedFavorites, _):
                                let evs = containedEvents.events
                                DispatchQueue.main.sync {
                                    do {
                                        let ctx = HICoreDataController.shared.persistentContainer.viewContext
                                        try? ctx.fetch(locationsFetchRequest).forEach {
                                            ctx.delete($0)
                                        }
                                        try? ctx.fetch(eventsFetchRequest).forEach {
                                            ctx.delete($0)
                                        }
                                        var events = [Event]()
                                        evs.forEach { event in
                                            events.append(Event(context: ctx, event: event, locations: NSSet()))
                                        }
                                        HILocalNotificationController.shared.scheduleNotifications(for: events)

                                        isRefreshing = false
                                    }
                                }
                                var updatedEvents = [HIAPI.Event]()
                                containedEvents.events.forEach { event in
                                    var event = event
                                    event.favorite = containedFavorites.events.map { $0 }.contains(event.name)
                                    updatedEvents.append(event)
                                }
                            case .failure:
                                isRefreshing = false
                            }
                        }
                        .authorize(with: HIApplicationStateController.shared.user)
                        .launch()
                case .failure:
                    isRefreshing = false
                }
            }
            .launch()
    }

    static private func setEventNotifications(containedLocations: HIAPI.Location.Contained,
                                              updatedEvents: [HIAPI.Event]) {
        DispatchQueue.main.sync {
            do {
                let ctx = HICoreDataController.shared.persistentContainer.viewContext
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
                // FIXME:
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
