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

//    public static func create(title: String, description: String) -> APIRequest<AnnouncementContainer> {
//        var announcementDict = HTTPBody()
//        announcementDict["title"]       = title
//        announcementDict["description"] = description
//        return APIRequest<AnnouncementContainer>(service: self, endpoint: "", body: announcementDict, method: .POST)
//    }

//    public static func update(announcement: Announcement) -> APIRequest<AnnouncementContainer> {
//        var announcementDict = HTTPBody()
//        announcementDict["title"]       = announcement.title
//        announcementDict["description"] = announcement.info
//        return APIRequest<AnnouncementContainer>(service: self, endpoint: "", body: announcementDict, method: .PUT)
//    }

    public static func getAllAnnouncements() -> APIRequest<AnnouncementContainer> {
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "all/", method: .GET)
    }

//    public static func delete(announcement: Announcement) -> APIRequest<AnnouncementContainer> {
//        let params = HTTPParameters()
//        return APIRequest<AnnouncementContainer>(service: self, endpoint: "\(announcement.topic.rawValue)/", params: params, method: .DELETE)
//    }
}
