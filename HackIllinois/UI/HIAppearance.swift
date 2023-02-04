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
    let neonCountdownText: UIColor
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
    let buttonPink: UIColor
    let buttonBlue: UIColor
    let buttonDarkBlue: UIColor
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
    
    let profileCardBackground: UIColor
    let profileCardVegetarian: UIColor
    let profileCardVegan: UIColor
    let profileCardGlutenFree: UIColor
    let profileCardLactoseIntolerant: UIColor
    let profileCardOther: UIColor
    let profileCardNone: UIColor

    
    let profileBaseText: UIColor

    let clear: UIColor = .clear
    let black: UIColor = .black
    let white: UIColor = .white

    //Hack 2022 color palette
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
    // Hack 2023 color palette
    private static let lightYellow = #colorLiteral(red: 0.9882352941, green: 0.862745098, blue: 0.5607843137, alpha: 1)
    private static let blue = #colorLiteral(red: 0.03137254902, green: 0.5450980392, blue: 0.7568627451, alpha: 1)
    private static let pink = #colorLiteral(red: 0.9960784314, green: 0.4392156863, blue: 0.5960784314, alpha: 1)
    private static let mediumOrange = #colorLiteral(red: 0.9764705882, green: 0.5843137255, blue: 0.3411764706, alpha: 1)
    private static let teal = #colorLiteral(red: 0.2156862745, green: 0.8705882353, blue: 0.8039215686, alpha: 1)
    private static let lightBlue = #colorLiteral(red: 0.7921568627, green: 0.8235294118, blue: 0.8980392157, alpha: 1)
    private static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private static let darkBlue = #colorLiteral(red: 0.05098039216, green: 0.2196078431, blue: 0.4862745098, alpha: 1)
    private static let transparent = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

    // Hack 2023 color palette
    private static let vegetarian = #colorLiteral(red: 0.2156862745, green: 0.8705882353, blue: 0.8039215686, alpha: 1)
    private static let vegan = #colorLiteral(red: 0.9882352941, green: 0.862745098, blue: 0.5607843137, alpha: 1)
    private static let glutenfree = #colorLiteral(red: 0.9764705882, green: 0.5843137255, blue: 0.3411764706, alpha: 1)
    private static let lactoseintolerant = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private static let other = #colorLiteral(red: 0.9960784314, green: 0.6392156863, blue: 0.6666666667, alpha: 1)
    private static let none = #colorLiteral(red: 0.1137254902, green: 0.1490196078, blue: 0.2666666667, alpha: 1)
    private static let profileBaseText = #colorLiteral(red: 0.1137254902, green: 0.1490196078, blue: 0.2666666667, alpha: 1)

    private static let transparent2 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    private static var statusBarWhite: UIStatusBarStyle {
        return .lightContent
    }
    private static var statusBarBlack: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }

    fileprivate static let day = HIAppearance(
        neonCountdownText: lightYellow,
        titleText: lightBlack,
        whiteText: white,
        baseText: lightBlack,
        accent: orange,
        action: tan,
        baseBackground: white,
        contentBackground: lightBlue,
        overlay: #colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.1803921569, alpha: 0.33),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        codePopupTab: white,
        navbarBackground: darkBlue,
        navbarTabTint: white,
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
        buttonPink: pink,
        buttonBlue: blue,
        buttonDarkBlue: darkBlue,
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
        leaderboardBackgroundOne: lightBlue,
        leaderboardBackgroundTwo: lightBlue,
        pointsBackground: white,
        profileCardBackground: lightBlue,
        profileCardVegetarian: vegetarian,
        profileCardVegan: profileBaseText,
        profileCardGlutenFree: glutenfree,
        profileCardLactoseIntolerant: lactoseintolerant,
        profileCardOther: other,
        profileCardNone: none,
        profileBaseText: profileBaseText
    )
    
    fileprivate static let night = HIAppearance(
        neonCountdownText: lightYellow,
        titleText: lightBlack,
        whiteText: white,
        baseText: lightBlack,
        accent: orange,
        action: tan,
        baseBackground: white,
        contentBackground: lightBlue,
        overlay: #colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.1803921569, alpha: 0.33),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        codePopupTab: white,
        navbarBackground: darkBlue,
        navbarTabTint: white,
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
        buttonPink: pink,
        buttonBlue: blue,
        buttonDarkBlue: darkBlue,
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
        leaderboardBackgroundOne: lightBlue,
        leaderboardBackgroundTwo: lightBlue,
        pointsBackground: white,
        profileCardBackground: lightBlue,
        profileCardVegetarian: vegetarian,
        profileCardVegan: vegan,
        profileCardGlutenFree: glutenfree,
        profileCardLactoseIntolerant: lactoseintolerant,
        profileCardOther: other,
        profileCardNone: none,
        profileBaseText: profileBaseText
    )

    fileprivate static var current = day

    static func change(to newAppearance: HIAppearance) {
        guard current != newAppearance else { return }
        current = newAppearance
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }

    enum Font {
        static let glyphPad = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let timeIndicator = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let homeSegmentedTitlePad = UIFont.systemFont(ofSize: 40, weight: .bold)
        static let viewTitlePad = UIFont.systemFont(ofSize: 48, weight: .bold)
        static let scheduleSegmentedNumberPad = UIFont.systemFont(ofSize: 36, weight: .semibold)
        static let scheduleSegmentedPad = UIFont.systemFont(ofSize: 32, weight: .semibold)
        static let eventTitlePad = UIFont.systemFont(ofSize: 36, weight: .bold)
        static let timeTextPad = UIFont.systemFont(ofSize: 28, weight: .semibold)
        static let locationTextPad = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let sponsorTextPad = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let detailTextPad = UIFont.systemFont(ofSize: 24, weight: .regular)
        static let contentSubtitle = UIFont(name: "MontserratRoman-Light", size: 13)
        static let contentText = UIFont(name: "MontserratRoman-Regular", size: 14)
        static let contentTitle = UIFont(name: "MontserratRoman-Medium", size: 18)
        static let detailTitle = UIFont(name: "MontserratRoman-SemiBold", size: 24)
        static let detailSubtitle = UIFont(name: "MontserratRoman-Medium", size: 16)
        static let detailText = UIFont(name: "MontserratRoman-Regular", size: 16)
        static let viewTitle = UIFont(name: "MontserratRoman-Bold", size: 24)
        static let happeningEventTitle = UIFont(name: "MontserratRoman-Bold", size: 25)
        static let eventTitle = UIFont(name: "MontserratRoman-SemiBold", size: 18)
        static let eventTime = UIFont(name: "MontserratRoman-Regular", size: 15)
        static let eventDetails = UIFont(name: "MontserratRoman-Regular", size: 14)
        static let eventButtonText = UIFont(name: "MontserratRoman-SemiBold", size: 12)
        static let eventCategoryText = UIFont(name: "MontserratRoman-Regular", size: 16)
        static let clockText = UIFont(name: "MontserratRoman-SemiBold", size: 48)
        static let navigationSubtitle = UIFont(name: "MontserratRoman-Medium", size: 14)
        static let navigationTitle = UIFont(name: "MontserratRoman-SemiBold", size: 22)
        static let navigationInfoText = UIFont(name: "MontserratRoman-Regular", size: 12)
        static let descriptionText = UIFont(name: "MontserratRoman-Regular", size: 16)
        static let timeText = UIFont(name: "MontserratRoman-SemiBold", size: 14)
        static let locationText = UIFont(name: "MontserratRoman-SemiBold", size: 12)
        static let bubbleSponsorText = UIFont(name: "MontserratRoman-SemiBold", size: 12)
        static let sponsorText = UIFont(name: "MontserratRoman-Regular", size: 16)
        static let loginTitle = UIFont(name: "MontserratRoman-Bold", size: 24)
        static let loginOrTitle = UIFont(name: "MontserratRoman-Bold", size: 16)
        static let loginSelection = UIFont(name: "MontserratRoman-SemiBold", size: 16)

        static let sectionHeader = UIFont(name: "MontserratRoman-Bold", size: 13)
        static let button = UIFont(name: "MontserratRoman-Regular", size: 15)
        static let glyph = UIFont(name: "MontserratRoman-Bold", size: 16)

        static let profileName = UIFont(name: "MontserratRoman-Bold", size: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)
        static let profileSubtitle = UIFont(name: "MontserratRoman-Bold", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 12)
        static let profileDietaryRestrictions = UIFont(name: "MontserratRoman-SemiBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16)
        static let profileDietaryRestrictionsLabel = UIFont(name: "MontserratRoman-Bold", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 12)
        static let profileTier = UIFont(name: "MontserratRoman-Bold", size: UIDevice.current.userInterfaceIdiom == .pad ? 36 : 18)
 
        
        static let profileNumberFigure = UIFont(name: "MontserratRoman-SemiBold", size: 24)
        static let profileUsername = UIFont(name: "MontserratRoman-Bold", size: 16)
        static let profileInterests = UIFont(name: "MontserratRoman-SemiBold", size: 14)
        static let segmentedTitle = UIFont(name: "MontserratRoman-Bold", size: 16)
        static let homeSegmentedTitle = UIFont(name: "MontserratRoman-Bold", size: 24)
        static let segmentedNumberText = UIFont(name: "MontserratRoman-SemiBold", size: 18)
       

        static let countdownText = UIFont(name: "MontserratRoman-Bold", size: 25)
        static let newCountdownText = UIFont(name: "MontserratRoman-Bold", size: 48)
        static let onboardingGetStartedText = UIFont(name: "MontserratRoman-SemiBold", size: 25)
        static let onboardingTitle = UIFont(name: "MontserratRoman-Bold", size: 30)
        static let onboardingDescription = UIFont(name: "MontserratRoman-Regular", size: 20)
        static let leaderboardPoints = UIFont(name: "MontserratRoman-SemiBold", size: 12)
        static let leaderboardName = UIFont(name: "MontserratRoman-SemiBold", size: 16)
        static let leaderboardRank = UIFont(name: "MontserratRoman-Bold", size: 24)
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
