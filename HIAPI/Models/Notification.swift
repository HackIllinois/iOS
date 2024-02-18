//
//  Notification.swift
//  HIAPI
//
//  Created by HackIllinois on 2/18/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

public struct NotificationContainer: Decodable, APIReturnable {
    public let success: Bool?
    public let status: String?
    public let error: String?
}

