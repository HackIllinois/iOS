//
//  HITextField.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITextField: UITextField {
    // MARK: - Types
    enum Style {
        case standard(placeholder: String)
        case username
        case password
    }

    // MARK: - Properties
    let style: Style

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)

        enablesReturnKeyAutomatically = true
        translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .standard(let placeholder):
            self.placeholder = placeholder

        case .username:
            placeholder = "USERNAME"
            textContentType = .username
            keyboardType = .emailAddress
            autocapitalizationType = .none
            autocorrectionType = .no

        case .password:
            placeholder = "PASSWORD"
            textContentType = .password
            isSecureTextEntry = true
            returnKeyType = .go
            autocapitalizationType = .none
            autocorrectionType = .no
        }

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
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
        textColor = HIAppearance.current.primary
        font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tintColor = HIAppearance.current.accent
        backgroundColor = HIAppearance.current.background

        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedStringKey.foregroundColor: HIAppearance.current.primary.withAlphaComponent(0.5)
                ]
            )
        }
    }
}
