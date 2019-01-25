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
    public static func create(event: Event) -> APIRequest<Event.Contained> {
        let eventDict = [String: Any]()
        return APIRequest<Event.Contained>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    public static func getAllEvents(active: Bool = false) -> APIRequest<Event.Contained> {
        let paramaters = ["active": "\(active)"]
        return APIRequest<Event.Contained>(service: self, endpoint: "", params: paramaters, method: .GET)
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
    public static func favortieBy(id: Int) -> APIRequest<Favorite.Contained> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<Favorite.Contained>(service: self, endpoint: "/favorite", body: body, method: .POST)
    }

    public static func unfavortieBy(id: Int) -> APIRequest<SuccessContainer> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<SuccessContainer>(service: self, endpoint: "/favorite", body: body, method: .DELETE)
    }

    public static func getAllFavorites() -> APIRequest<Favorite.Contained> {
        return APIRequest<Favorite.Contained>(service: self, endpoint: "/favorite", method: .GET)
    }
}
