//
//  HIAnnouncementService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIAnnouncementService: HIBaseService {

    override class var baseURL: String {
        return super.baseURL + "/announcement"
    }

    class func create(announcement: Announcement) -> APIRequest<Announcement.Contained> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = announcement.title
        announcementDict["description"] = announcement.info
        return APIRequest<Announcement.Contained>(service: self, endpoint: "", body: announcementDict, method: .POST)
    }

    class func update(announcement: Announcement) -> APIRequest<Announcement.Contained> {
        var announcementDict = [String: Any]()
        announcementDict["title"]       = announcement.title
        announcementDict["description"] = announcement.info
        return APIRequest<Announcement.Contained>(service: self, endpoint: "", body: announcementDict, method: .PUT)
    }

    class func getAllAnnouncements(after: Date? = nil, before: Date? = nil, limit: Int? = nil) -> APIRequest<Announcement.Contained> {
        var params = [String: String]()
        if let after = after { params["after"] = Formatter.iso8601.string(from: after)  }
        if let before = before { params["before"] = Formatter.iso8601.string(from: before) }
        if let limit = limit { params["limit"] = String(limit) }
        return APIRequest<Announcement.Contained>(service: self, endpoint: "/all", params: params, method: .GET)
    }

    class func delete(announcement: Announcement) -> APIRequest<Announcement.Contained> {
        var params = [String: String]()
        params["id"] = String(announcement.id)
        return APIRequest<Announcement.Contained>(service: self, endpoint: "", params: params, method: .DELETE)
    }

}
