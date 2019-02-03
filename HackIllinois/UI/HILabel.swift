//
//  HILabel.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/21/18.
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
            textHIColor = \.generalText
            backgroundHIColor = \.clear
            font = UIFont.systemFont(ofSize: 13, weight: .bold)

        case .event:
            textHIColor = \.generalText
            backgroundHIColor = \.clear
            font = UIFont.systemFont(ofSize: 18, weight: .light)

        case .title:
            textHIColor = \.generalText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = UIFont.systemFont(ofSize: 15, weight: .medium)

        case .subtitle:
            textHIColor = \.accent
            backgroundHIColor = \.clear
            font = UIFont.systemFont(ofSize: 13, weight: .light)

        case .description:
            textHIColor = \.generalText
            backgroundHIColor = \.clear
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            numberOfLines = 0

        case .loginHeader:
            textHIColor = \.accent
            backgroundHIColor = \.baseBackground
            font = UIFont.systemFont(ofSize: 15, weight: .medium)

        case .loginSelection:
            textHIColor = \.generalText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = UIFont.systemFont(ofSize: 13, weight: .medium)
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
