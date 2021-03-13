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
    let qrTint: UIColor
    let qrBackground: UIColor
    let emptyTableViewBackground: UIImage
    let preferredStatusBarStyle: UIStatusBarStyle
    let scrollViewIndicatorStyle: UIScrollView.IndicatorStyle
    let mapBackground: UIColor
    let loginDefault: UIColor
    let loginTitleBackground: UIColor
    let loginLogo: UIImage
    let viewTitleColor: UIColor
    let loginSelectionText: UIColor
    let attendeeText: UIColor
    let attendeeBackground: UIColor
    let whiteTagFont: UIColor
    let interestBackground: UIColor
    let segmentedBackground: UIColor
    let buttonBlue: UIColor

    // New fonts added. Replace old ones?
    let groupText: UIColor
    let memberSearchText: UIColor
    let groupSearchText: UIColor
    let buttonViewBackground: UIColor
    let checkmark: UIImage

    let eventTypeGreen: UIColor
    let eventTypeOrange: UIColor
    let eventTypeRed: UIColor
    let eventTypePurple: UIColor

    let clear: UIColor = .clear
    let black: UIColor = .black

    private static let darkBlue = #colorLiteral(red: 0.1326064765, green: 0.1667878032, blue: 0.3605746627, alpha: 1)
    private static let blue = #colorLiteral(red: 0.1215686275, green: 0.5176470588, blue: 0.6470588235, alpha: 1)
    private static let buttonblue = #colorLiteral(red: 0.231372549, green: 0.4078431373, blue: 0.6509803922, alpha: 1)
    private static let lightBlue = #colorLiteral(red: 0.4196078431, green: 0.6823529412, blue: 0.7725490196, alpha: 1)
    private static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private static let orange = #colorLiteral(red: 0.8901960784, green: 0.3137254902, blue: 0.3450980392, alpha: 1)
    private static let transparent = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    private static let coral = #colorLiteral(red: 1, green: 0.4666666667, blue: 0.4352941176, alpha: 1)
    private static let maroon = #colorLiteral(red: 0.6431372549, green: 0.231372549, blue: 0.3607843137, alpha: 1)
    private static let deepBlue = #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.2470588235, alpha: 1)
    private static let darkerBlue = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.3607843137, alpha: 1)
    private static let whiteBlue = #colorLiteral(red: 0.9764705882, green: 1, blue: 1, alpha: 1)
    private static let greyWhite = #colorLiteral(red: 0.9764705882, green: 1, blue: 1, alpha: 1)

    private static let lightCoral = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.4470588235, alpha: 1)
    private static let nightBlue = #colorLiteral(red: 0.4352941176, green: 0.5490196078, blue: 0.7568627451, alpha: 1)

    // New colors added. Replace old ones?
    private static let grayBlack = #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
    private static let groupRed = #colorLiteral(red: 0.8151133363, green: 0.1137254902, blue: 0.137254902, alpha: 1)
    private static let groupOrange = #colorLiteral(red: 0.937254902, green: 0.5176470588, blue: 0.2823529412, alpha: 1)
    private static let buttonBlue = #colorLiteral(red: 0.231372549, green: 0.4078431373, blue: 0.6509803922, alpha: 1)

    private static let eventGreen = #colorLiteral(red: 0.1568627451, green: 0.3960784314, blue: 0.4549019608, alpha: 1)
    private static let eventOrange = #colorLiteral(red: 0.8941176471, green: 0.4117647059, blue: 0.2901960784, alpha: 1)
    private static let eventRed = #colorLiteral(red: 0.5960784314, green: 0.1137254902, blue: 0.137254902, alpha: 1)
    private static let eventPurple = #colorLiteral(red: 0.3490196078, green: 0.2784313725, blue: 0.6549019608, alpha: 1)

    private static var statusBarWhite: UIStatusBarStyle {
        if #available(iOS 13, *) {
             return .lightContent
        } else {
             return .default
        }
    }

    fileprivate static let day = HIAppearance(
        titleText: white,
        whiteText: white,
        baseText: darkBlue,
        accent: orange,
        action: white,
        baseBackground: white,
        contentBackground: white,
        overlay: #colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.1803921569, alpha: 0.33),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        qrTint: darkBlue,
        qrBackground: white,
        emptyTableViewBackground: #imageLiteral(resourceName: "EmptyTableViewDay"),
        preferredStatusBarStyle: statusBarWhite,
        scrollViewIndicatorStyle: .black,
        mapBackground: whiteBlue,
        loginDefault: nightBlue,
        loginTitleBackground: white,
        loginLogo: #imageLiteral(resourceName: "HILogo"),
        viewTitleColor: deepBlue,
        loginSelectionText: white,
        attendeeText: white,
        attendeeBackground: lightCoral,
        whiteTagFont: white,
        interestBackground: lightCoral,
        segmentedBackground: greyWhite,
        buttonBlue: buttonblue,
        groupText: grayBlack,
        memberSearchText: groupOrange,
        groupSearchText: groupRed,
        buttonViewBackground: buttonBlue,
        checkmark: #imageLiteral(resourceName: "CheckMark"),
        eventTypeGreen: eventGreen,
        eventTypeOrange: eventOrange,
        eventTypeRed: eventRed,
        eventTypePurple: eventPurple
)

    fileprivate static let night = HIAppearance(
        titleText: white,
        whiteText: white,
        baseText: darkBlue,
        accent: orange,
        action: white,
        baseBackground: white,
        contentBackground: white,
        overlay: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.47),
        frostedTint: #colorLiteral(red: 0, green: 0.3411764706, blue: 0.462745098, alpha: 0.6),
        qrTint: darkBlue,
        qrBackground: white,
        emptyTableViewBackground: #imageLiteral(resourceName: "EmptyTableViewNight"),
        preferredStatusBarStyle: statusBarWhite,
        scrollViewIndicatorStyle: .white,
        mapBackground: whiteBlue,
        loginDefault: nightBlue,
        loginTitleBackground: white,
        loginLogo: #imageLiteral(resourceName: "HILogo"),
        viewTitleColor: deepBlue,
        loginSelectionText: white,
        attendeeText: white,
        attendeeBackground: lightCoral,
        whiteTagFont: white,
        interestBackground: lightCoral,
        segmentedBackground: greyWhite,
        buttonBlue: buttonblue,
        groupText: grayBlack,
        memberSearchText: groupOrange,
        groupSearchText: groupRed,
        buttonViewBackground: buttonBlue,
        checkmark: #imageLiteral(resourceName: "CheckMark"),
        eventTypeGreen: eventGreen,
        eventTypeOrange: eventOrange,
        eventTypeRed: eventRed,
        eventTypePurple: eventPurple
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
        static let detailText = UIFont.systemFont(ofSize: 15, weight: .regular)

        static let eventTitle = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let eventTime = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let eventDetails = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let eventButtonText = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let eventCategoryText = UIFont.systemFont(ofSize: 12, weight: .semibold)

        static let navigationSubtitle = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let navigationTitle = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let navigationInfoText = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let descriptionText = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let sponsorText = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let loginTitle = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let loginSelection = UIFont.systemFont(ofSize: 16, weight: .semibold)

        static let sectionHeader = UIFont.systemFont(ofSize: 13, weight: .bold)
        static let button = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let glyph = UIFont.systemFont(ofSize: 21, weight: .light)

        static let profileName = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let profileSubtitle = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let profileNumberFigure = UIFont.systemFont(ofSize: 20, weight: .medium)
        static let profileDescription = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let profileUsername = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let profileInterests = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let segmentedTitle = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let segmentedNumberText = UIFont.systemFont(ofSize: 20, weight: .semibold)

        static let groupContact = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let groupStatus = UIFont.systemFont(ofSize: 12, weight: .bold)
        static let sortingText = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let countdownText = UIFont.systemFont(ofSize: 25, weight: .bold)
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
