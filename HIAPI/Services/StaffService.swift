//
//  EventService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/04/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public class StaffService: BaseService {
    
    public override class var baseURL: String {
        return super.baseURL
    }
    
    public static func getStaffShifts(authToken: String) -> APIRequest<ShiftContainer> {
        var header = HTTPHeaders()
        header["Authorization"] = authToken
        return APIRequest<ShiftContainer>(service: self, endpoint: "staff/shift/", method: .GET)
    }
    
}
