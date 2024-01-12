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
    static let SHOULD_SHOW_ONBOARDING_KEY = "org.hackillinois.ios.should_show_onboarding"
    static func PASS_PROMPTED_KEY(user: HIUser) -> String {
        return "org.hackillinois.ios.pass_prompted_\(user.userId)"
    }
    // Images
    private static let url = "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2022/"

    static let PROFILE_IMAGES: [String: HIImage] = [
        "\(url)profile-0.png": \.profile0,
        "\(url)profile-1.png": \.profile1,
        "\(url)/profile-2.png": \.profile2,
        "\(url)/profile-3.png": \.profile3,
        "\(url)/profile-4.png": \.profile4,
        "\(url)/profile-5.png": \.profile5,
        "\(url)/profile-6.png": \.profile6,
        "\(url)/profile-7.png": \.profile7,
        "\(url)/profile-8.png": \.profile8,
        "\(url)/profile-9.png": \.profile9,
        "\(url)/profile-10.png": \.profile10
    ]
    static let LEADERBOARD_PROFILE_LIMIT = 10
    static let MAX_EVENT_DESCRIPTION_LENGTH = 75
    static let ASYNC_EVENT_TIME_TEXT = "All Day"
    static let ONLINE_EVENT_LOCATION_TEXT = "Online"
}
