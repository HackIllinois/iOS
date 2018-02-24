//
//  HITableView.swift
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
