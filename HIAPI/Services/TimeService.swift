//
//  TimeService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/27/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class TimeService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "upload/blobstore/times/"
    }

    public static func getTimes() -> APIRequest<TimeContainer> {
        return APIRequest<TimeContainer>(service: self, endpoint: "", method: .GET)
    }
}
