//
//  HIEventService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager
import CoreData

final class HIEventService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/event"
    }

    // MARK: Events
    static func create(event: HIAPIEvent) -> APIRequest<HIAPIEvent.Contained> {
        let eventDict = [String: Any]()
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", body: eventDict, method: .POST)
    }

    static func getAllEvents(active: Bool = false) -> APIRequest<HIAPIEvent.Contained> {
        let paramaters = ["active": "\(active)"]
        return APIRequest<HIAPIEvent.Contained>(service: self, endpoint: "", params: paramaters, method: .GET)
    }

    // MARK: Locations
    static func create(location: HIAPILocation) -> APIRequest<HIAPILocation.Contained> {
        let locationDict = [String: Any]()
        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location", body: locationDict, method: .POST)
    }

    static func getAllLocations() -> APIRequest<HIAPILocation.Contained> {
        return APIRequest<HIAPILocation.Contained>(service: self, endpoint: "/location/all", method: .GET)
    }
}
