//
//  InterestService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/5/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class InterestService: BaseService {
    public override static var baseURL: String {
        return super.baseURL + "upload/blobstore/interests/"
    }

    public static func getInterests() -> APIRequest<InterestContainer> {
        return APIRequest<InterestContainer>(service: self, endpoint: "", method: .GET)
    }
}
