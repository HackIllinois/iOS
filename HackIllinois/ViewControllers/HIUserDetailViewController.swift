//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import PassKit
import os
import HIAPI

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let qrContainerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let qrImageView = HITintImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.contentMode = .scaleAspectFit
    }
    private let userNameLabel = HILabel {
        $0.textHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.font = HIAppearance.Font.navigationTitle
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private let userInfoLabel = HILabel {
        $0.textHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.font = HIAppearance.Font.contentText
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}

// MARK: - Actions
extension HIUserDetailViewController {
    @objc func didSelectLogoutButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Logout", style: .destructive) { _ in
                NotificationCenter.default.post(name: .logoutUser, object: nil)
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.popoverPresentationController?.barButtonItem = sender
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIUserDetailViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(containerView)
        containerView.addSubview(qrContainerView)
        qrContainerView.addSubview(qrImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(userInfoLabel)

        containerView.constrain(to: view.safeAreaLayoutGuide, topInset: 12, trailingInset: -12, leadingInset: 12)
        view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: 12).isActive = true

        qrContainerView.constrain(to: containerView, topInset: 32, trailingInset: -32, leadingInset: 32)
        qrContainerView.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -22).isActive = true

        userNameLabel.constrain(to: containerView, trailingInset: -32, leadingInset: 32)
        userNameLabel.bottomAnchor.constraint(equalTo: userInfoLabel.topAnchor, constant: -2).isActive = true

        userInfoLabel.constrain(to: containerView, trailingInset: -32, bottomInset: -32, leadingInset: 32)

        qrImageView.centerXAnchor.constraint(equalTo: qrContainerView.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: qrContainerView.centerYAnchor).isActive = true

        qrImageView.topAnchor.constraint(greaterThanOrEqualTo: qrContainerView.topAnchor).isActive = true
        qrImageView.leadingAnchor.constraint(greaterThanOrEqualTo: qrContainerView.leadingAnchor).isActive = true
        qrContainerView.trailingAnchor.constraint(greaterThanOrEqualTo: qrImageView.trailingAnchor).isActive = true
        qrContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: qrImageView.bottomAnchor).isActive = true

        qrImageView.widthAnchor.constraint(equalTo: qrImageView.heightAnchor, multiplier: 1).isActive = true

        let width = qrImageView.widthAnchor.constraint(equalTo: qrContainerView.widthAnchor, multiplier: 1)
        width.priority = UILayoutPriority(rawValue: 500)
        width.isActive = true
        let height = qrImageView.heightAnchor.constraint(equalTo: qrContainerView.heightAnchor, multiplier: 1)
        height.priority = UILayoutPriority(rawValue: 500)
        height.isActive = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
            let url = user.qrURL else { return }
        view.layoutIfNeeded()
        let size = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage = UIImage(qrString: url.absoluteString, size: size)?.withRenderingMode(.alwaysTemplate)
            DispatchQueue.main.async {
                self.qrImageView.image = qrImage
            }
        }
        userNameLabel.text = user.firstName.uppercased()
        userInfoLabel.text = user.attendee?.diet.description ?? "NO DIETARY RESTRICTIONS"
        setupPass()
    }
}

// MARK: - Passbook/Wallet support
extension HIUserDetailViewController {
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
            let user = HIApplicationStateController.shared.user,
            let url = user.qrURL,
            !UserDefaults.standard.bool(forKey: HIConstants.PASS_PROMPTED_KEY(user: user)) else { return }
        HIAPI.PassService.getPass(qr: url.absoluteString, identifier: user.email)
        .onCompletion { result in
            do {
                let (data, _) = try result.get()
                let pass = try PKPass(data: data)
                guard let passVC = PKAddPassesViewController(pass: pass) else {
                    throw HIError.passbookError
                }
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        UserDefaults.standard.set(true, forKey: HIConstants.PASS_PROMPTED_KEY(user: user))
                        strongSelf.present(passVC, animated: true, completion: nil)
                    }
                }
            } catch {
                os_log(
                    "Error initializing PKPass: %s",
                    log: Logger.ui,
                    type: .error,
                    String(describing: error)
                )
            }
        }
        .launch()
    }
}

// MARK: - UINavigationItem Setup
extension HIUserDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LogoutButton"), style: .plain, target: self, action: #selector(didSelectLogoutButton(_:)))
    }
}
