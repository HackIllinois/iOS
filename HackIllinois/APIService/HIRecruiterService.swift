//
//  HIRecruiterService.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

final class HIRecruiterService: HIBaseService {
    override static var baseURL: String {
        return super.baseURL + "/recruiters"
    }
    
    static func followUserBy(id: Int) -> APIRequest<HIAPISuccessContainer> {
        var body = HTTPBody()
        body["id"] = id
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "/apply", body: body, method: .POST)
    }

    static func followedUsers(id: Int) -> APIRequest<HIAPISuccessContainer> {
        var body = HTTPBody()
        body["id"] = id
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "/apply", body: body, method: .POST)
    }

}
