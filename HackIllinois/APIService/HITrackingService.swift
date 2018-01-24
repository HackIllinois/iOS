//
//  HITrackingService.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/23/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HITrackingService: HIBaseService {
    
    override class var baseURL: String {
        return super.baseURL + "/tracking"
    }
        
    class func githubLoginURL() -> URL {
        guard let url = URL(string: baseURL + "?isMobile=1") else {
            fatalError()
        }
        return url
    }
    
//    class func found(meta: String, data:) -> APIRequest<HIUserAuth.Contained> {
//        var body = [String: String]()
//        body =
//        return APIRequest<HIUserAuth.Contained>(service: self, endpoint: "", body: body, method: .GET)
//    }
}
