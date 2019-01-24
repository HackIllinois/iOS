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
    static func create(event: HIAPIEvent) -> APIRequest<HIAPIEvent> {
        let eventDict = [String: Any]()
        return APIRequest<HIAPIEvent>(service: self, endpoint: "/", body: eventDict, method: .POST)
    }

    static func getAllEvents() -> APIRequest<HIAPIEvent.Contained> {
        let paramaters = ["Content-Type": "application/json"]
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "/", params: paramaters, method: .GET)
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
    static func favoriteBy(token: String, name: String) -> APIRequest<HIAPIFavorite> {
        var headers = HTTPHeaders()
        headers["Authorization"] = token
        var body = HTTPBody()
        body["eventName"] = name
        return APIRequest<HIAPIFavorite>(service: self, endpoint: "/favorite/add/", body: body, headers: headers, method: .POST)
    }

    static func unfavoriteBy(token: String, name: String) -> APIRequest<HIAPIFavorite> {
        var headers = HTTPHeaders()
        headers["Authorization"] = token
        var body = HTTPBody()
        body["eventName"] = name
        return APIRequest<HIAPIFavorite>(service: self, endpoint: "/favorite/remove/", body: body, headers: headers, method: .POST)
    }

    static func getAllFavorites(token: String) -> APIRequest<HIAPIFavorite> {
        var headers = HTTPHeaders()
        headers["Authorization"] = token
        return APIRequest<HIAPIFavorite>(service: self, endpoint: "/favorite/", headers: headers, method: .GET)
    }
}
