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
        return super.baseURL + "announcement/"
    }

    public static func create(title: String, description: String) -> APIRequest<AnnouncementContainer> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = title
        announcementDict["description"] = description
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "", body: announcementDict, method: .POST)
    }

    public static func update(announcement: Announcement) -> APIRequest<AnnouncementContainer> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = announcement.title
        announcementDict["description"] = announcement.info
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "", body: announcementDict, method: .PUT)
    }

    public static func getAllAnnouncements(after: Date? = nil, before: Date? = nil, limit: Int? = nil) -> APIRequest<AnnouncementContainer> {
        var params = [String: String]()
        if let after = after { params["after"] = "\(after.timeIntervalSince1970)" }
        if let before = before { params["before"] = "\(before.timeIntervalSince1970)" }
        if let limit = limit { params["limit"] = String(limit) }
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "all/", params: params, method: .GET)
    }

    public static func delete(announcement: Announcement) -> APIRequest<AnnouncementContainer> {
        var params = [String: String]()
        params["id"] = String(announcement.id)
        return APIRequest<AnnouncementContainer>(service: self, endpoint: "", params: params, method: .DELETE)
    }
}
