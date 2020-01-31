//
//  HIView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/20/18.
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
        case separator
        case emptyTable
    }

    // MARK: - Properties
    let style: Style?
    var backgroundHIColor: HIColor?

    // MARK: - Init
    init(style: Style? = nil, additionalConfiguration: ((HIView) -> Void)? = nil) {
        self.style = style
        super.init(frame: .zero)
        additionalConfiguration?(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)

        if let style = style {
            switch style {
            case .separator:
                backgroundHIColor = \.accent
                translatesAutoresizingMaskIntoConstraints = false
                heightAnchor.constraint(equalToConstant: 1).isActive = true

            case .emptyTable:
                backgroundHIColor = \.baseBackground
                let backgroundImageView = HIImageView {
                    $0.hiImage = \.emptyTableViewBackground
                    $0.contentMode = .scaleAspectFit
                    $0.translatesAutoresizingMaskIntoConstraints = false
                }
                addSubview(backgroundImageView)
                backgroundImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
                backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
                backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                let centerConstraint = NSLayoutConstraint(item: backgroundImageView,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .centerY,
                                   multiplier: 0.66,
                                   constant: 0.0)
                centerConstraint.priority = .defaultHigh
                centerConstraint.isActive = true
                let label = HILabel(style: .backgroundTitle) {
                    $0.text = "CHECK BACK LATER"
                    $0.setContentCompressionResistancePriority(.required, for: .vertical)
                }
                addSubview(label)
                label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 12).isActive = true
                label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                label.bottomAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
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
        backgroundColor <- backgroundHIColor
    }
}
