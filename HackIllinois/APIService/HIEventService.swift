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
    class func create(event: HIEvent) -> APIRequest<HIAuthService, HIEventContained> {
        let eventDict = [String: Any]()
        return APIRequest<HIAuthService, HIEventContained>(endpoint: "", body: eventDict, method: .POST)
    }

    class func getAllEvents(active: Bool = false) -> APIRequest<HIAuthService, HIEventContained> {
        return APIRequest<HIAuthService, HIEventContained>(endpoint: "", params: ["active": "\(active)"], method: .GET)
    }

    // MARK: Locations
    class func create(location: HILocation) -> APIRequest<HIAuthService, HILocationContained> {
        let locationDict = [String: Any]()
        return APIRequest<HIAuthService, HILocationContained>(endpoint: "/location", body: locationDict, method: .POST)
    }

    class func getAllLocations() -> APIRequest<HIAuthService, HILocationsContained> {
        return APIRequest<HIAuthService, HILocationsContained>(endpoint: "/location/all", method: .GET)
    }
}
