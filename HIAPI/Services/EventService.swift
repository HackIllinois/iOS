//
//  EventService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager
import CoreData

public final class EventService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "/event"
    }

    // MARK: - Events
    public static func create(event: Event) -> APIRequest<EventContainer> {
        let eventDict = [String: Any]()
        return APIRequest<EventContainer>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    public static func getAllEvents(active: Bool = false) -> APIRequest<EventContainer> {
        let paramaters = ["active": "\(active)"]
        return APIRequest<EventContainer>(service: self, endpoint: "", params: paramaters, method: .GET)
    }

    // MARK: - Locations
//    public static func create(location: Location) -> APIRequest<Location.Contained> {
//        let locationDict = [String: Any]()
//        return APIRequest<Location.Contained>(service: self, endpoint: "/location", body: locationDict, method: .POST)
//    }

    public static func getAllLocations() -> APIRequest<Location.Contained> {
        return APIRequest<Location.Contained>(service: self, endpoint: "/location/all", method: .GET)
    }

    // MARK: - Favorties
    public static func favoriteBy(name: String) -> APIRequest<Favorite> {
        var body = HTTPBody()
        body["eventName"] = name
        return APIRequest<Favorite>(service: self, endpoint: "favorite/add/", body: body, method: .POST)
    }

    public static func unfavoriteBy(name: String) -> APIRequest<Favorite> {
        var body = HTTPBody()
        body["eventName"] = name
        return APIRequest<Favorite>(service: self, endpoint: "favorite/remove/", body: body, method: .POST)
    }

    public static func getAllFavorites() -> APIRequest<Favorite> {
        return APIRequest<Favorite>(service: self, endpoint: "favorite/", method: .GET)
    }
}
