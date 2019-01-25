//
//  Notifications.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/4/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

extension Notification.Name {
    static let themeDidChange = Notification.Name("HINotificationThemeDidChange")
    static let loginUser  = Notification.Name("HIApplicationStateControllerLoginUser")
    static let logoutUser = Notification.Name("HIApplicationStateControllerLogoutUser")
}
