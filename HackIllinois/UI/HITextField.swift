//
//  HITextField.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/19/18.
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
    enum FieldType {
        case defaultTextField
        case editProfile
    }

    // MARK: - Properties
    var textHIColor: HIColor? // = \.baseText
    var tintHIColor: HIColor? // = \.accent
    var backgroundHIColor: HIColor? // = \.baseBackground

    // MARK: - Init
    init(style: FieldType? = .defaultTextField, additionalConfiguration: ((HITextField) -> Void)? = nil) {
        super.init(frame: .zero)
        additionalConfiguration?(self)

//        font = HIAppearance.Font.navigationSubtitle
        switch style {
        case .defaultTextField:
            textHIColor = \.baseText
            tintHIColor = \.accent
            backgroundHIColor = \.baseBackground
        case .editProfile:
            font = HIAppearance.Font.profileDescription.withSize(18)
            textHIColor = \.whiteTagFont
            tintHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            let bottomView = HIView { (view) in
                view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundHIColor = \.whiteTagFont
                view.alpha = 0.5
            }

            self.addSubview(bottomView)
            bottomView.constrain(to: self, trailingInset: 0, bottomInset: 0, leadingInset: 0)
            self.returnKeyType = .done
            self.delegate = self
        default:
            break
        }

        enablesReturnKeyAutomatically = true
        translatesAutoresizingMaskIntoConstraints = false

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
        textColor <- textHIColor
        tintColor <- tintHIColor
        backgroundColor <- backgroundHIColor

        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: (textHIColor == nil ? \HIAppearance.baseText : textHIColor!).value.withAlphaComponent(0.5)
                ]
            )
        }
    }
}

// MARK: - UITextFieldDelegate
extension HITextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
