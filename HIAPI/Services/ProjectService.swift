//
//  ProjectService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/20/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public class ProjectService: BaseService {

    public override class var baseURL: String {
        return super.baseURL + "project/"
    }

    public static func getAllProjects() -> APIRequest<ProjectContainer> {
        return APIRequest<ProjectContainer>(service: self, endpoint: "", method: .GET)
    }

    public static func getAllFavorites() -> APIRequest<ProjectFavorites> {
        return APIRequest<ProjectFavorites>(service: self, endpoint: "favorite/", method: .GET)
    }

    public static func favoriteBy(id: String) -> APIRequest<ProjectFavorites> {
        var body = HTTPBody()
        body["projectId"] = id
        return APIRequest<ProjectFavorites>(service: self, endpoint: "favorite/add/", body: body, method: .POST)
    }

    public static func unfavoriteBy(id: String) -> APIRequest<ProjectFavorites> {
        var body = HTTPBody()
        body["projectId"] = id
        return APIRequest<ProjectFavorites>(service: self, endpoint: "favorite/remove/", body: body, method: .POST)
    }

}
