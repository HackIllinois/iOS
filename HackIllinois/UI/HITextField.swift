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
    // MARK: - Properties

    // MARK: - Init
    init(additionalConfiguration: ((HITextField) -> Void)? = nil) {
        super.init(frame: .zero)
        additionalConfiguration?(self)

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
        font = UIFont.systemFont(ofSize: 13, weight: .medium)
        textColor <- \.generalText
        tintColor <- \.accent
        backgroundColor <- \.baseBackground

        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: (\HIAppearance.generalText).value.withAlphaComponent(0.5)
                ]
            )
        }
    }
}
