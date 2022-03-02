//
//  HIAppearance.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/4/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit

struct HIAppearance: Equatable {
    let titleText: UIColor
    let whiteText: UIColor
    let baseText: UIColor
    let accent: UIColor
    let action: UIColor
    let baseBackground: UIColor
    let contentBackground: UIColor
    let overlay: UIColor
    let frostedTint: UIColor
    let codePopupTab: UIColor
    let navbarBackground: UIColor
    let navbarTabTint: UIColor
    let profileContainerTint: UIColor
    let preferredStatusBarStyle: UIStatusBarStyle
    let scrollViewIndicatorStyle: UIScrollView.IndicatorStyle
    let loginDefault: UIColor
    let loginTitleBackground: UIColor
    let loginLogo: UIImage
    let loginSelectionText: UIColor
    let attendeeText: UIColor
    let attendeeBackground: UIColor
    let whiteTagFont: UIColor
    let interestBackground: UIColor
    let buttonGreen: UIColor
    let favoriteStarBackground: UIColor
    let segmentedBackground: UIColor
    // New fonts added. Replace old ones?
    let buttonViewBackground: UIColor
    let profile0: UIImage
    let profile1: UIImage
    let profile2: UIImage
    let profile3: UIImage
    let profile4: UIImage
    let profile5: UIImage
    let profile6: UIImage
    let profile7: UIImage
    let profile8: UIImage
    let profile9: UIImage
    let profile10: UIImage

    let leaderboardText: UIColor
    let leaderboardBackgroundOne: UIColor
    let leaderboardBackgroundTwo: UIColor
    let pointsBackground: UIColor

    let clear: UIColor = .clear
    let black: UIColor = .black
    let white: UIColor = .white

    // Hack 2022 color palette
    private static let darkRed = #colorLiteral(red: 0.6039215686, green: 0.1411764706, blue: 0.168627451, alpha: 1)
    private static let tan = #colorLiteral(red: 0.9098039216, green: 0.8431372549, blue: 0.6470588235, alpha: 1)
    private static let orange = #colorLiteral(red: 0.9294117647, green: 0.6078431373, blue: 0.1294117647, alpha: 1)
    private static let darkOrange = #colorLiteral(red: 0.7882352941, green: 0.4117647059, blue: 0.1568627451, alpha: 1)
    private static let lightBlueGreen = #colorLiteral(red: 0.8470588235, green: 0.9254901961, blue: 0.8470588235, alpha: 1)
    private static let maroon = #colorLiteral(red: 0.6392156863, green: 0.2941176471, blue: 0.2588235294, alpha: 1)
    private static let lightRed = #colorLiteral(red: 0.9019607843, green: 0.5960784314, blue: 0.5568627451, alpha: 1)
    private static let yellowGreen = #colorLiteral(red: 0.7882352941, green: 0.8117647059, blue: 0.462745098, alpha: 1)
    private static let green = #colorLiteral(red: 0.4705882353, green: 0.6745098039, blue: 0.2588235294, alpha: 1)
    private static let lightBlack = #colorLiteral(red: 0.03137254902, green: 0.08235294118, blue: 0.1058823529, alpha: 1)
    private static let salmon = #colorLiteral(red: 0.9490196078, green: 0.6078431373, blue: 0.4705882353, alpha: 1)
    private static let yellowWhite = #colorLiteral(red: 0.9647058824, green: 0.9568627451, blue: 0.831372549, alpha: 1)
    private static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private static let transparent = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

    private static var statusBarWhite: UIStatusBarStyle {
        return .lightContent
    }
    private static var statusBarBlack: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    fileprivate static let day = HIAppearance(
        titleText: lightBlack,
        whiteText: white,
        baseText: lightBlack,
        accent: orange,
        action: tan,
        baseBackground: white,
        contentBackground: yellowWhite,
        overlay: #colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.1803921569, alpha: 0.33),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        codePopupTab: orange,
        navbarBackground: green,
        navbarTabTint: yellowWhite,
        profileContainerTint: yellowWhite,
        preferredStatusBarStyle: statusBarBlack,
        scrollViewIndicatorStyle: .black,
        loginDefault: lightBlack,
        loginTitleBackground: lightBlack,
        loginLogo: #imageLiteral(resourceName: "HILogo"),
        loginSelectionText: lightBlack,
        attendeeText: lightBlack,
        attendeeBackground: yellowGreen,
        whiteTagFont: white,
        interestBackground: orange,
        buttonGreen: yellowGreen,
        favoriteStarBackground: yellowWhite,
        segmentedBackground: white,
        buttonViewBackground: green,
        profile0: #imageLiteral(resourceName: "Profile0"),
        profile1: #imageLiteral(resourceName: "Profile1"),
        profile2: #imageLiteral(resourceName: "Profile2"),
        profile3: #imageLiteral(resourceName: "Profile3"),
        profile4: #imageLiteral(resourceName: "Profile4"),
        profile5: #imageLiteral(resourceName: "Profile5"),
        profile6: #imageLiteral(resourceName: "Profile6"),
        profile7: #imageLiteral(resourceName: "Profile7"),
        profile8: #imageLiteral(resourceName: "Profile8"),
        profile9: #imageLiteral(resourceName: "Profile9"),
        profile10: #imageLiteral(resourceName: "Profile10"),
        leaderboardText: lightBlack,
        leaderboardBackgroundOne: yellowWhite,
        leaderboardBackgroundTwo: tan,
        pointsBackground: yellowGreen
    )

    fileprivate static let night = HIAppearance(
        titleText: lightBlack,
        whiteText: white,
        baseText: lightBlack,
        accent: orange,
        action: tan,
        baseBackground: white,
        contentBackground: yellowWhite,
        overlay: #colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.1803921569, alpha: 0.33),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        codePopupTab: orange,
        navbarBackground: green,
        navbarTabTint: yellowWhite,
        profileContainerTint: yellowWhite,
        preferredStatusBarStyle: statusBarBlack,
        scrollViewIndicatorStyle: .black,
        loginDefault: lightBlack,
        loginTitleBackground: lightBlack,
        loginLogo: #imageLiteral(resourceName: "HILogo"),
        loginSelectionText: lightBlack,
        attendeeText: lightBlack,
        attendeeBackground: yellowGreen,
        whiteTagFont: white,
        interestBackground: orange,
        buttonGreen: yellowGreen,
        favoriteStarBackground: yellowWhite,
        segmentedBackground: white,
        buttonViewBackground: green,
        profile0: #imageLiteral(resourceName: "Profile0"),
        profile1: #imageLiteral(resourceName: "Profile1"),
        profile2: #imageLiteral(resourceName: "Profile2"),
        profile3: #imageLiteral(resourceName: "Profile3"),
        profile4: #imageLiteral(resourceName: "Profile4"),
        profile5: #imageLiteral(resourceName: "Profile5"),
        profile6: #imageLiteral(resourceName: "Profile6"),
        profile7: #imageLiteral(resourceName: "Profile7"),
        profile8: #imageLiteral(resourceName: "Profile8"),
        profile9: #imageLiteral(resourceName: "Profile9"),
        profile10: #imageLiteral(resourceName: "Profile10"),
        leaderboardText: lightBlack,
        leaderboardBackgroundOne: yellowWhite,
        leaderboardBackgroundTwo: tan,
        pointsBackground: yellowGreen
    )

    fileprivate static var current = day

    static func change(to newAppearance: HIAppearance) {
        guard current != newAppearance else { return }
        current = newAppearance

        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }

    enum Font {
        static let contentSubtitle = UIFont.systemFont(ofSize: 13, weight: .light)
        static let contentText = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let contentTitle = UIFont.systemFont(ofSize: 18, weight: .medium)
        static let detailTitle = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let detailSubtitle = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let detailText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let viewTitle = UIFont.systemFont(ofSize: 28, weight: .semibold)
        static let happeningEventTitle = UIFont.systemFont(ofSize: 25, weight: .bold)
        static let eventTitle = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let eventTime = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let eventDetails = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let eventButtonText = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let eventCategoryText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let clockText = UIFont.systemFont(ofSize: 48, weight: .semibold)
        static let navigationSubtitle = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let navigationTitle = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let navigationInfoText = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let descriptionText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let sponsorText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let loginTitle = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let loginOrTitle = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let loginSelection = UIFont.systemFont(ofSize: 16, weight: .semibold)

        static let sectionHeader = UIFont.systemFont(ofSize: 13, weight: .bold)
        static let button = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let glyph = UIFont.systemFont(ofSize: 15, weight: .light)

        static let profileName = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let profileSubtitle = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let profileNumberFigure = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let profileTier = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let profileUsername = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let profileInterests = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let segmentedTitle = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let segmentedNumberText = UIFont.systemFont(ofSize: 20, weight: .semibold)

        static let countdownText = UIFont.systemFont(ofSize: 25, weight: .bold)
        static let onboardingGetStartedText = UIFont.systemFont(ofSize: 25, weight: .semibold)
        static let onboardingTitle = UIFont.systemFont(ofSize: 30, weight: .bold)
        static let onboardingDescription = UIFont.systemFont(ofSize: 20, weight: .regular)
        static let leaderboardPoints = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let leaderboardName = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let leaderboardRank = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
}

// MARK: - HIApperanceKeyPath
extension KeyPath where Root == HIAppearance {
    var value: Value {
        return HIAppearance.current[keyPath: self]
    }
}

// MARK: - HIColor
typealias HIColor = KeyPath<HIAppearance, UIColor>

extension UIColor {
    static func <- (lhs: inout UIColor, rhs: HIColor) {
        lhs = rhs.value
    }
}

extension Optional where Wrapped == UIColor {
    static func <- (lhs: inout UIColor?, rhs: HIColor) {
        lhs = rhs.value
    }

    static func <- (lhs: inout UIColor?, rhs: HIColor?) {
        lhs = rhs?.value
    }
}

// MARK: - HIImage
typealias HIImage = KeyPath<HIAppearance, UIImage>

extension UIImage {
    static func <- (lhs: inout UIImage, rhs: HIImage) {
        lhs = rhs.value
    }
}

extension Optional where Wrapped == UIImage {
    static func <- (lhs: inout UIImage?, rhs: HIImage) {
        lhs = rhs.value
    }

    static func <- (lhs: inout UIImage?, rhs: HIImage?) {
        lhs = rhs?.value
    }
}

// MARK: - HIStatusBarStyle
typealias HIStatusBarStyle = KeyPath<HIAppearance, UIStatusBarStyle>

extension UIStatusBarStyle {
    static func <- (lhs: inout UIStatusBarStyle, rhs: HIStatusBarStyle) {
        lhs = rhs.value
    }
}

extension Optional where Wrapped == UIStatusBarStyle {
    static func <- (lhs: inout UIStatusBarStyle?, rhs: HIStatusBarStyle) {
        lhs = rhs.value
    }

    static func <- (lhs: inout UIStatusBarStyle?, rhs: HIStatusBarStyle?) {
        lhs = rhs?.value
    }
}

// MARK: - HIStatusBarStyle
typealias HIScrollViewIndicatorStyle = KeyPath<HIAppearance, UIScrollView.IndicatorStyle>

extension UIScrollView.IndicatorStyle {
    static func <- (lhs: inout UIScrollView.IndicatorStyle, rhs: HIScrollViewIndicatorStyle) {
        lhs = rhs.value
    }
}

extension Optional where Wrapped == UIScrollView.IndicatorStyle {
    static func <- (lhs: inout UIScrollView.IndicatorStyle?, rhs: HIScrollViewIndicatorStyle) {
        lhs = rhs.value
    }

    static func <- (lhs: inout UIScrollView.IndicatorStyle?, rhs: HIScrollViewIndicatorStyle?) {
        lhs = rhs?.value
    }
}

// MARK: - HIThemeEngine
class HIThemeEngine {
    static let shared = HIThemeEngine()

    // MARK: - Properties
    var timer: Timer?

    // MARK: - Init
    private init() {
        startUpTimer()
    }

    deinit {
        tearDownTimer()
    }

    // MARK: - Theme Timer
    func startUpTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 300, // every 5 minutes
            target: self,
            selector: #selector(updateThemeIfNeeded),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }

    @objc func updateThemeIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        guard let sunrise = calendar.date(bySettingHour: 6, minute: 30, second: 0, of: now),
            let sunset = calendar.date(bySettingHour: 17, minute: 30, second: 0, of: now) else { return }

        let newAppearance: HIAppearance
        if now >= sunrise && now <= sunset {
            newAppearance = .day
        } else {
            newAppearance = .night
        }
        HIAppearance.change(to: newAppearance)
    }

    func tearDownTimer() {
        timer?.invalidate()
        timer = nil
    }
}
