//
//  HITableView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HITableView: UITableView {
    // MARK: - Types
    enum Style {
        case standard
    }

    // MARK: - Properties
    let style_: Style

    // MARK: - Init
    init(style: Style) {
        self.style_ = style
        super.init(frame: .zero, style: .grouped)
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
        translatesAutoresizingMaskIntoConstraints = false
        switch HIApplication.Theme.current {
        case .day:
            indicatorStyle = .black
        case .night:
            indicatorStyle = .white
        }
        switch style_ {
        case .standard:
            backgroundColor = HIApplication.Palette.current.background

        }
    }

}
