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
        return super.baseURL + "/requests"
    }
    
    static func recruiterRequest(name: String, duration: Int) -> APIRequest<HIAPISuccessContainer> {
        var eventDict = [String: Any]()
        eventDict["attendeeUserId"] = name
        return APIRequest<HIAPISuccessContainer>(service: self, endpoint: "recruiterInterestRequest", body: eventDict, method: .POST)
    }
    
}
