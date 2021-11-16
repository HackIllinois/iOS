//
//  ProfileService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class ProfileService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "profile/"
    }

    public static func getUserProfile() -> APIRequest<Profile> {
        return APIRequest<Profile>(service: self, endpoint: "", headers: headers, method: .GET)
    }

    public static func getMatchingProfiles(teamStatus: [String], interests: [String]) -> APIRequest<ProfileContainer> {
        var params = HTTPParameters()
        if teamStatus.count == 0 && interests.count == 0 {
            return APIRequest<ProfileContainer>(service: self, endpoint: "search/", headers: headers, method: .GET)
        }
        if teamStatus.count > 0 {
            params["teamStatus"] = teamStatus.joined(separator: ",")
        }
        if interests.count > 0 {
            params["interests"] = interests.joined(separator: ",")
        }
        return APIRequest<ProfileContainer>(service: self, endpoint: "search/", params: params, headers: headers, method: .GET)
    }

    public static func updateUserProfile(profileData: [String: Any]) -> APIRequest<Profile> {
        return APIRequest<Profile>(service: self, endpoint: "", body: profileData, headers: headers, method: .PUT)
    }

    public static func getAllFavorites() -> APIRequest<ProfileFavorites> {
        return APIRequest<ProfileFavorites>(service: self, endpoint: "favorite/", method: .GET)
    }

    public static func favoriteBy(id: String) -> APIRequest<ProfileFavorites> {
        var body = HTTPBody()
        body["id"] = id
        return APIRequest<ProfileFavorites>(service: self, endpoint: "favorite/add/", body: body, method: .POST)
    }

    public static func unfavoriteBy(id: String) -> APIRequest<ProfileFavorites> {
        var body = HTTPBody()
        body["id"] = id
        return APIRequest<ProfileFavorites>(service: self, endpoint: "favorite/remove/", body: body, method: .POST)
    }
}
