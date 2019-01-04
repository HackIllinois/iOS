//
//  HIImageView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIImageView: UIImageView {
    // MARK: - Types
    enum Style {
        case icon(image: UIImage)
    }

    // MARK: - Properties
    let style: Style

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .icon(let image):
            self.image = image.withRenderingMode(.alwaysTemplate)
            contentMode = .center
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
        tintColor = HIAppearance.current.accent
    }
}
