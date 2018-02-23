//
//  HIImageView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
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
        tintColor = HIApplication.Palette.current.accent
    }
}
