//
//  HIView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/20/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIView: UIView {
    // MARK: - Types
    enum Style {
        case background
        case content
        case separator
    }

    // MARK: - Properties
    let style: Style

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)

        switch style {
        case .background:
            backgroundColor = HIApplication.Color.paleBlue

        case .content:
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = HIApplication.Color.white
            layer.cornerRadius = 8
            layer.masksToBounds = true

        case .separator:
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = HIApplication.Color.hotPink
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}
