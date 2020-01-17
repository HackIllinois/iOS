//
//  HILoginSelectionHeader.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HILoginSelectionHeader: UITableViewHeaderFooterView {
    // MARK: - Properties
    var titleLabel = HILabel(style: .loginHeader)
    var welcomeLabel = HILabel(style: .viewTitle)

    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let containerView = HIView { $0.backgroundHIColor = \.baseBackground }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true

        let logoImageView = HIImageView {
            $0.hiImage = \.loginLogo
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        containerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true

        containerView.addSubview(welcomeLabel)
        welcomeLabel.textAlignment = .center
        welcomeLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        containerView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 250).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - UITableViewHeaderFooterView
extension HILoginSelectionHeader {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
