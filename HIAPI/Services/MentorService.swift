//
//  MentorService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/10/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class MentorService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "mentor/"
    }
    
    public static func recordMentorAttendance(userToken: String, mentorId: String) -> APIRequest<MentorAttendanceContainer> {
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        var body = HTTPBody()
        body["mentorId"] = mentorId
        return APIRequest<MentorAttendanceContainer>(service: self, endpoint: "attendance/", body: body, headers: headers, method: .POST)
    }
    
}
