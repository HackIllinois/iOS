//
//  NotificationService.swift
//  HIAPI
//
//  Created by HackIllinois on 2/18/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

public final class NotificationService: BaseService {
    public override static var baseURL: String {
        return super.baseURL
    }
    
    public static func sendDeviceToken(deviceToken: String) -> APIRequest<NotificationContainer> {
        var body = HTTPBody()
        body["deviceToken"] = deviceToken
        return APIRequest<NotificationContainer>(service: self, endpoint: "notification/", body: body, method: .POST)
    }
}
