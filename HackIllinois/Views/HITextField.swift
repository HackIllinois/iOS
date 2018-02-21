//
//  HITextField.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
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

        textColor = HIApplication.Color.darkIndigo
        font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tintColor = HIApplication.Color.hotPink
        backgroundColor = UIColor.clear
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

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}
