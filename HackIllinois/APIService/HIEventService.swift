//
//  HIEventService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIEventService: HIBaseService {
    override class var baseURL: String {
        return super.baseURL + "/event"
    }

    // MARK: Events
    class func create(event: Event) -> APIRequest<Event.Contained> {
        let eventDict = [String: Any]()
        return APIRequest<Event.Contained>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    class func getAllEvents(active: Bool = false) -> APIRequest<Event.Contained> {
        return APIRequest<Event.Contained>(service: self, endpoint: "", params: ["active": "\(active)"], method: .GET)
    }

    // MARK: Locations
    class func create(location: Location) -> APIRequest<Location.Contained> {
        let locationDict = [String: Any]()
        return APIRequest<Location.Contained>(service: self, endpoint: "/location", body: locationDict, method: .POST)
    }

    class func getAllLocations() -> APIRequest<Location.Contained> {
        return APIRequest<Location.Contained>(service: self, endpoint: "/location/all", method: .GET)
    }
}
