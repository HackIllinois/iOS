//
//  HIErrorView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/5/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

protocol HIErrorViewDelegate: class {
    func didSelectErrorLogout(_ sender: UIButton)
}
class HIErrorView: HIView {
    enum ErrorType {
        case codePopup
        case profile
        case teamMatching
    }
    // MARK: - Properties
    weak var delegate: HIErrorViewDelegate?
    var errorLabel = HILabel()
    var logoutButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.interestBackground
        $0.titleHIColor = \.action
        $0.title = "Log Out"
        $0.titleLabel?.font = HIAppearance.Font.detailSubtitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }

    // MARK: - Init
    init(style: ErrorType?, additionalConfiguration: ((HIErrorView) -> Void)? = nil) {
        super.init()
        additionalConfiguration?(self)
        switch style {
        case .codePopup:
            errorLabel = HILabel(style: .codeError)
            errorLabel.text = "You need to log out of your current account and log in as an attendee to earn points."
        case .profile:
            errorLabel = HILabel(style: .error)
            errorLabel.text = "You need to log out of your current account and log in as an attendee to see your profile."
        case .teamMatching:
            errorLabel = HILabel(style: .error)
            errorLabel.text = "You need to log out of your current account and log in as an attendee to see other profiles."
        default:
            break
        }
        isUserInteractionEnabled = true

        self.addSubview(errorLabel)
        errorLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        self.addSubview(logoutButton)
        logoutButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

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

}

// MARK: - Actions
extension HIErrorView {
    @objc func didSelectLogoutButton(_ sender: UIButton) {
        delegate?.didSelectErrorLogout(sender)
    }
}
