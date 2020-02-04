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
        case location
        case event
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
        case .location:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText

        case .event:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentTitle

        case .detailTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailTitle
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
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.descriptionText
            numberOfLines = 0

        case .cellDescription:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText
            numberOfLines = 1

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

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        textColor <- textHIColor
        backgroundColor <- backgroundHIColor
    }
}
