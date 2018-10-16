//
//  HIAnnouncementService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

final class HIAnnouncementService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/announcement"
    }

    static func create(title: String, description: String) -> APIRequest<HIAPIAnnouncement.Contained> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = title
        announcementDict["description"] = description
        return APIRequest<HIAPIAnnouncement.Contained>(service: self, endpoint: "", body: announcementDict, method: .POST)
    }

    static func update(announcement: HIAPIAnnouncement) -> APIRequest<HIAPIAnnouncement.Contained> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = announcement.title
        announcementDict["description"] = announcement.info
        return APIRequest<HIAPIAnnouncement.Contained>(service: self, endpoint: "", body: announcementDict, method: .PUT)
    }

    static func getAllAnnouncements(after: Date? = nil, before: Date? = nil, limit: Int? = nil) -> APIRequest<HIAPIAnnouncement.Contained> {
        var params = [String: String]()
        if let after = after { params["after"] = Formatter.iso8601.string(from: after)  }
        if let before = before { params["before"] = Formatter.iso8601.string(from: before) }
        if let limit = limit { params["limit"] = String(limit) }
        return APIRequest<HIAPIAnnouncement.Contained>(service: self, endpoint: "/all", parameters: params, method: .GET)
    }

    static func delete(announcement: HIAPIAnnouncement) -> APIRequest<HIAPIAnnouncement.Contained> {
        var params = [String: String]()
        params["id"] = String(announcement.id)
        return APIRequest<HIAPIAnnouncement.Contained>(service: self, endpoint: "", parameters: params, method: .DELETE)
    }
}
