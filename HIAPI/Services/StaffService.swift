//
//  StaffService.swift
//  HIAPI
//
//  Created by Dev Patel on 2/7/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
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
    
    public static func recordStaffAttendance(userToken: String) -> APIRequest<StaffAttendanceContainer> {
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        return APIRequest<StaffAttendanceContainer>(service: self, endpoint: "attendance/", headers: headers, method: .POST)
    }
    
    public static func recordUserAttendance(userToken: String) -> APIRequest<UserAttendanceContainer> {
        var headers = HTTPHeaders()
        headers["Authorization"] = userToken
        return APIRequest<UserAttendanceContainer>(service: self, endpoint: "scan-attendee/", headers: headers, method: .PUT)
    }
}
