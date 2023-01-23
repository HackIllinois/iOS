//
//  HIDateHeader.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIDateHeader: UITableViewHeaderFooterView {
    var titleLabel = HILabel {
        $0.textHIColor = \.titleText
        $0.backgroundHIColor = \.clear
        $0.font = HIAppearance.Font.sectionHeader
    }
    let dateView = HIView { (view) in
        view.layer.cornerRadius = 10
        view.backgroundHIColor = \.buttonDarkBlue
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let backgroundView = HIView { $0.backgroundHIColor = \.clear }
        self.backgroundView = backgroundView
        backgroundView.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        var spacingConstant: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            spacingConstant = 2.0
        }
        dateView.addSubview(titleLabel)
        dateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -8).isActive = true
        dateView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        titleLabel.constrain(to: dateView, topInset: 4 * spacingConstant, trailingInset: -8 * spacingConstant, bottomInset: -4 * spacingConstant, leadingInset: 8 * spacingConstant)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
