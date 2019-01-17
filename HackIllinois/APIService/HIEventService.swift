//
//  HIEventService.swift
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

final class HIEventService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/event"
    }

    // MARK: - Events
    static func create(event: HIAPIEvent) -> APIRequest<HIAPIEvent.Contained> {
        let eventDict = [String: Any]()
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    static func getAllEvents(active: Bool = false) -> APIRequest<HIAPIEvent.Contained> {
        let paramaters = ["active": "\(active)"]
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", params: paramaters, method: .GET)
    }

    // MARK: - Locations
//    static func create(location: HIAPILocation) -> APIRequest<HIAPILocation.Contained> {
//        let locationDict = [String: Any]()
//        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location", body: locationDict, method: .POST)
//    }

    static func getAllLocations() -> APIRequest<HIAPILocation.Contained> {
        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location/all", method: .GET)
    }

    // MARK: - Favorties
    static func favortieBy(id: Int) -> APIRequest<HIAPIFavorite.Contained> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<HIAPIFavorite.Contained>(service: self, endpoint: "/favorite", body: body, method: .POST)
    }

    static func unfavortieBy(id: Int) -> APIRequest<HIAPISuccessContainer> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "/favorite", body: body, method: .DELETE)
    }

    static func getAllFavorites() -> APIRequest<HIAPIFavorite.Contained> {
        return APIRequest<HIAPIFavorite.Contained>(service: self, endpoint: "/favorite", method: .GET)
    }
}
