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
        return super.baseURL + "/recruiter"
    }

    static func followUserBy(id: Int) -> APIRequest<HIAPISuccessContainer> {
        var body = HTTPBody()
        body["attendeeUserId"] = id
        body["favorite"] = true
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "/interest", body: body, method: .POST)
    }
}
