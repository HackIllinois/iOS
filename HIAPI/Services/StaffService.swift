//
//  StaffService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/7/24.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class StaffService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "staff/"
    }

    public static func getStaffShift(userToken: String) -> APIRequest<StaffContainer> {
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        return APIRequest<StaffContainer>(service: self, endpoint: "shift/", headers: headers, method: .GET)
    }
    
    public static func recordStaffAttendance(userToken: String, eventId: String) -> APIRequest<StaffAttendanceContainer> {
        var body = HTTPBody()
        body["eventId"] = eventId
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        return APIRequest<StaffAttendanceContainer>(service: self, endpoint: "attendance/", body: body, headers: headers, method: .POST)
    }
    
    public static func recordUserAttendance(userToken: String, userId: String, eventId: String) -> APIRequest<UserAttendanceContainer> {
        var body = HTTPBody()
        body["userId"] = userId
        body["eventId"] = eventId
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        return APIRequest<UserAttendanceContainer>(service: self, endpoint: "scan-attendee/", body: body, headers: headers, method: .PUT)
    }
}
