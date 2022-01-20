//
//  HILabel.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HILabel: UILabel {
    // MARK: - Types
    enum Style {
        case happeningEvents
        case location
        case event
        case eventTime
        case eventType
        case sponsor
        case project
        case title
        case detailTitle
        case subtitle
        case description
        case cellDescription
        case loginHeader
        case loginSelection
        case viewTitle
        case backgroundTitle
        case detailSubtitle
        case detailText
        case profileName
        case profileSubtitle
        case profileNumberFigure
        case profileTier
        case profileUsername
        case profileInterests
        case navigationInfo
        case groupDescription
        case groupNameInfo
        case groupContactInfo
        case groupStatus
        case sortText
        case sortElement
        case countdown
        case pointsText
        case groupStatusFilter
        case characterCount
        case error
        case codeError
        case onboardingDescription
        case onboardingTitle
    }

    // MARK: - Properties
    let style: Style?

    var textHIColor: HIColor?
    var backgroundHIColor: HIColor?

    // MARK: - Init
    // Waive swiftlint warning
    // swiftlint:disable:next function_body_length
    init(style: Style? = nil, additionalConfiguration: ((HILabel) -> Void)? = nil) {
        self.style = style
        super.init(frame: .zero)
        additionalConfiguration?(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)

        translatesAutoresizingMaskIntoConstraints = false
        if let style = style {
        switch style {
        case .happeningEvents:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.happeningEventTitle

        case .location:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText

        case .event:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventTitle

        case .eventTime:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventTime

        case .eventType:
            textHIColor = \.accent
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventCategoryText
            textAlignment = .center

        case .sponsor:
            textHIColor = \.attendeeBackground
            backgroundHIColor = \.clear
            font = HIAppearance.Font.sponsorText

        case .detailTitle:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailTitle
            numberOfLines = 0

        case .detailSubtitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            numberOfLines = 0

        case .detailText:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailText
            numberOfLines = 0

        case .project:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentTitle

        case .title:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.contentTitle

        case .subtitle:
            textHIColor = \.accent
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentSubtitle

        case .description:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.descriptionText
            numberOfLines = 0

        case .cellDescription:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventDetails
            numberOfLines = 0

        case .loginHeader:
            textHIColor = \.loginTitleBackground
            backgroundHIColor = \.clear
            font = HIAppearance.Font.loginTitle

        case .viewTitle:
            textHIColor = \.loginSelectionText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.loginTitle

        case .backgroundTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.navigationSubtitle

        case .loginSelection:
            textHIColor = \.loginSelectionText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.loginSelection
            layer.borderWidth = 2.0
            layer.borderColor = (\HIAppearance.loginSelectionText).value.cgColor
            layer.backgroundColor = UIColor.clear.cgColor

        case .profileName: // Used to display the profile owner's name
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileName

        case .profileSubtitle: // Used to display profile subtitle, "points", and whatever that says "time zone"
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileSubtitle

        case .profileNumberFigure: // Used to display number of points and time (?)
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileNumberFigure

        case .profileTier: // Used to display "short description"
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .left
            font = HIAppearance.Font.profileTier

        case .profileUsername: // Used to display Discord username, etc.
            textHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            textAlignment = .left
            font = HIAppearance.Font.profileUsername

        case .profileInterests:
            textHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileInterests

        case .navigationInfo:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.navigationInfoText
            textAlignment = .center

        // New styles for group matching
        case .groupDescription:
            textHIColor = \.groupText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText
            numberOfLines = 2

        case .groupNameInfo:
            textHIColor = \.groupText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.groupName

        case .groupContactInfo:
            textHIColor = \.groupText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.groupContact

        case .groupStatus:
            backgroundHIColor = \.clear
            font = HIAppearance.Font.groupStatus

        case .sortText:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.sortingText

        case .sortElement:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText

        case .countdown:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.countdownText

        case .pointsText:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventButtonText
            textAlignment = .center

        case .groupStatusFilter:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.groupStatus
            numberOfLines = 0

        case .characterCount:
            textHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            font = HIAppearance.Font.characterCount

        case .error:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            textAlignment = .center
            numberOfLines = 0

        case .codeError:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            textAlignment = .center
            numberOfLines = 0
        case .onboardingDescription:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.onboardingDescription
            textAlignment = .center
            numberOfLines = 0
        case .onboardingTitle:
            textHIColor = \.whiteText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.onboardingTitle
            textAlignment = .center
            numberOfLines = 0

        }
        }

        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func changeTextColor(color: HIColor) {
        textColor <- color
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        textColor <- textHIColor
        backgroundColor <- backgroundHIColor
    }
}

// MARK: - Auto-Sizing
extension HILabel {
    static func heightForView(text: String, font: UIFont, width: CGFloat, numLines: Int = 0) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
   }
}
