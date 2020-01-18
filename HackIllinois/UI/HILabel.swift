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
        case title
        case subtitle
        case description
        case loginHeader
        case loginSelection
        case viewTitle
    }

    // MARK: - Properties
    let style: Style?

    var textHIColor: HIColor?
    var backgroundHIColor: HIColor?

    // MARK: - Init
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

        case .title:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.button

        case .subtitle:
            textHIColor = \.accent
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentSubtitle

        case .description:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText
            numberOfLines = 0

        case .loginHeader:
            textHIColor = \.loginTitleBackground
            backgroundHIColor = \.baseBackground
            font = HIAppearance.Font.loginTitle

        case .viewTitle:
            textHIColor = \.viewTitleColor
            backgroundHIColor = \.clear
            font = HIAppearance.Font.loginTitle

        case .loginSelection:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.navigationSubtitle
            layer.cornerRadius = 20.0
            layer.borderWidth = 2.0
            layer.borderColor = UIColor.red.cgColor //TODO: Replace red with actual colors
            layer.backgroundColor = UIColor.clear.cgColor //TODO: Replace red with actual colors
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
