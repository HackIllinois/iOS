//
//  HILabel.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HILabel: UILabel {
    // MARK: - Types
    enum Style {
        case date
        case location(text: String)
        case event(text: String)
        case title
        case subtitle
        case description
        case countdown(text: String)
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

        case .location(let text):
            self.text = text
            font = UIFont.systemFont(ofSize: 13, weight: .bold)

        case .event(let text):
            self.text = text
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
            backgroundColor = HIApplication.Palette.current.background
            textColor = HIApplication.Palette.current.primary

        case .location:
//            backgroundColor = HIApplication.Palette.current.contentBackground
            textColor = HIApplication.Palette.current.primary

        case .event:
//            backgroundColor = HIApplication.Palette.current.contentBackground
            textColor = HIApplication.Palette.current.primary

        case .title:
//            backgroundColor = HIApplication.Palette.current.background
            textColor = HIApplication.Palette.current.primary

        case .subtitle:
//            backgroundColor = HIApplication.Palette.current.background
            textColor = HIApplication.Palette.current.accent

        case .description:
            textColor = HIApplication.Palette.current.primary

        case .countdown:
            backgroundColor = HIApplication.Palette.current.background
            textColor = HIApplication.Palette.current.accent

        }
    }
}
