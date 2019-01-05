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
        case date
        case location
        case event
        case title
        case subtitle
        case description
        case countdown(text: String)
        case loginHeader
        case loginSelection
    }

    // MARK: - Properties
    let style: Style

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)

        translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .date:
            font = UIFont.systemFont(ofSize: 13, weight: .bold)

        case .location:
            font = UIFont.systemFont(ofSize: 13, weight: .bold)

        case .event:
            font = UIFont.systemFont(ofSize: 18, weight: .light)

        case .title:
            textAlignment = .center
            font = UIFont.systemFont(ofSize: 15, weight: .medium)

        case .subtitle:
            font = UIFont.systemFont(ofSize: 13, weight: .light)

        case .description:
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            numberOfLines = 0

        case .countdown(let text):
            self.text = text
            textAlignment = .center
            font = UIFont.systemFont(ofSize: 21, weight: .light)

        case .loginHeader:
            font = UIFont.systemFont(ofSize: 15, weight: .medium)

        case .loginSelection:
            textAlignment = .center
            font = UIFont.systemFont(ofSize: 13, weight: .medium)

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
        switch style {
        case .date:
            backgroundColor = HIAppearance.current.background
            textColor = HIAppearance.current.primary

        case .location:
//            backgroundColor = HIAppearance.current.contentBackground
            textColor = HIAppearance.current.primary

        case .event:
//            backgroundColor = HIAppearance.current.contentBackground
            textColor = HIAppearance.current.primary

        case .title:
//            backgroundColor = HIAppearance.current.background
            textColor = HIAppearance.current.primary

        case .subtitle:
//            backgroundColor = HIAppearance.current.background
            textColor = HIAppearance.current.accent

        case .description:
            textColor = HIAppearance.current.primary

        case .countdown:
            backgroundColor = HIAppearance.current.background
            textColor = HIAppearance.current.accent

        case .loginHeader:
            backgroundColor = HIAppearance.current.background
            textColor = HIAppearance.current.accent

        case .loginSelection:
            textColor = HIAppearance.current.primary

        }
    }
}
