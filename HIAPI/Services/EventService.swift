//
//  EventService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public class EventService: BaseService {

    public override class var baseURL: String {
        return super.baseURL + "event/"
    }

    public static func getAllEvents() -> APIRequest<EventContainer> {
        return APIRequest<EventContainer>(service: self, endpoint: "", method: .GET)
    }

    public static func checkIn(code: String) -> APIRequest<EventCheckInStatus> {
        var body = HTTPBody()
        body["code"] = code
        return APIRequest<EventCheckInStatus>(service: self, endpoint: "checkin/", body: body, method: .POST)
    }

    public static func create(event: Event) -> APIRequest<EventContainer> {
        let eventDict = [String: Any]()
        assert(false)
        return APIRequest<EventContainer>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    public static func getAllFavorites() -> APIRequest<EventFavorites> {
        return APIRequest<EventFavorites>(service: self, endpoint: "favorite/", method: .GET)
    }

    public static func favoriteBy(id: String) -> APIRequest<EventFavorites> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<EventFavorites>(service: self, endpoint: "favorite/add/", body: body, method: .POST)
    }

    public static func unfavoriteBy(id: String) -> APIRequest<EventFavorites> {
        var body = HTTPBody()
        body["eventId"] = id
        return APIRequest<EventFavorites>(service: self, endpoint: "favorite/remove/", body: body, method: .POST)
    }

}
