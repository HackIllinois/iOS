//
//  RecruiterService.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class RecruiterService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "/recruiter"
    }

    public static func followUserBy(id: Int) -> APIRequest<SuccessContainer> {
        var body = HTTPBody()
        body["attendeeUserId"] = id
        body["favorite"] = true
        return APIRequest<SuccessContainer>(service: self, endpoint: "/interest", body: body, method: .POST)
    }
}
