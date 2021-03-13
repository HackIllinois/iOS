//
//  Constants.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/24/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

// MARK: - Constants
struct HIConstants {
    // Keys
    static let STORED_ACCOUNT_KEY = "org.hackillinois.ios.active_account"
    static let STORED_PROFILE_KEY = "org.hackillinois.ios.active_profile"
    static let APPLICATION_INSTALLED_KEY = "org.hackillinois.ios.application_installed"
    static func PASS_PROMPTED_KEY(user: HIUser) -> String {
        return "org.hackillinois.ios.pass_prompted_\(user.id)"
    }
}
