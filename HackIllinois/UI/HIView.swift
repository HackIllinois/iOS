//
//  HIView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/20/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIView: UIView {
    // MARK: - Types
    enum Style {
        case background
        case content
        case separator
        case emptyTable
        case overlay
    }

    // MARK: - Properties
    let style: Style

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)

        switch style {
        case .background:
            break

        case .content:
            translatesAutoresizingMaskIntoConstraints = false
            layer.cornerRadius = 8
            layer.masksToBounds = true

        case .separator:
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 1).isActive = true

        case .emptyTable:
            let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "EmptyTableView"))
            backgroundImageView.contentMode = .scaleAspectFit
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(backgroundImageView)
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            NSLayoutConstraint(item: backgroundImageView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 0.7,
                               constant: 0.0).isActive = true

        case .overlay:
            translatesAutoresizingMaskIntoConstraints = false
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
        case .background:
            backgroundColor = HIApplication.Palette.current.background

        case .content:
            backgroundColor = HIApplication.Palette.current.contentBackground

        case .separator:
            backgroundColor = HIApplication.Palette.current.accent

        case .emptyTable:
            backgroundColor = HIApplication.Palette.current.background

        case .overlay:
            backgroundColor = HIApplication.Palette.current.overlay
        }
    }
}
