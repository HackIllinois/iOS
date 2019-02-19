//
//  AnnouncementService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class AnnouncementService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "notifications/"
    }

    public static func sendToken(deviceToken: String) -> APIRequest<SimpleRequest> {
        var announcementDict = [String: Any]()
        announcementDict["deviceToken"] = deviceToken
        announcementDict["platform"] = "ios"
        return APIRequest<SimpleRequest>(service: self, endpoint: "device/", body: announcementDict, method: .POST)
    }

    public static func updateSubscriptions() -> APIRequest<SimpleRequest> {
        return APIRequest<SimpleRequest>(service: self, endpoint: "update/", method: .POST)
    }

    public static func create(title: String, description: String, topic: String) -> APIRequest<SimpleRequest> {
        var announcementDict = HTTPBody()
        announcementDict["title"] = title
        announcementDict["body"] = description
        return APIRequest<SimpleRequest>(service: self, endpoint: "\(topic)/", body: announcementDict, method: .POST)
    }

    public static func getAllAnnouncements() -> APIRequest<AnnouncementContainer> {
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "all/", method: .GET)
    }
}
